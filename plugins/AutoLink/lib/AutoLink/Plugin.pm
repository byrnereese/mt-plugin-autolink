# AutoLink Movable Type Plugin
# Copyright (C) 2004-2008 Byrne Reese

package AutoLink::Plugin;

use strict;

use Carp qw( croak );
use MT::Util qw( relative_date offset_time offset_time_list epoch2ts ts2epoch format_ts );

# Linking strategy:
#

sub remove_autolink_tags {
    my ($txt) = @_;
    $txt =~ s!<a class="autolink" href="[^"]*">(.*)</a>!$1!gm;
    return $txt;
}

sub add_links {
    my ($text,$rules) = @_;
    foreach my $rule (@$rules) {
	my $href      = $rule->destination;
	my $pattern   = $rule->pattern;

	my $options = "";
	$options .= "g" if $rule->global;
	$options .= "i" if $rule->case_insensitive;

	my $cmd = "";
	# TODO - the text that is linked to needs to be tokenized and links added at the end
        if ($rule->regex) {
          $cmd = '$text =~ s!('.$pattern.')!<a class="autolink" href="'.$href.'">$1</a>!'.$options;
        } else {
          $cmd = '$text =~ s!\b('.$pattern.')\b!<a class="autolink" href="'.$href.'">$1</a>!'.$options;
        }
        eval $cmd;
    }
    return $text;
}


sub process_text {
    my ($text,$rules) = @_;

    my %tokens;
    my $count = 0;

    # Extract existing links from text
    while ($text =~ s/(<a [^\>]*\>.*?<\/a>)/"\${token-".++$count."}"/emi) {
	$tokens{"token-$count"} = $1;
    }

#    This should no longer be necessary as quicklink will be processed AFTER 
#       markdown, when the markdown syntax has been processed and removed.
#    if ($obj->convert_breaks eq "markdown") {
#	while ($text =~ s/(\[[^\]]*\]\([^\)]*\))/"\${token-".++$count."}"/emi) {
#	    $tokens{"token-$count"} = $1;
#	}
#    }
    
    $text = add_links($text, $rules);
    
    # Reassemble text with pre-existing links
    foreach my $key (keys %tokens) {
	$text =~ s/\${$key}/$tokens{$key}/emi;
    }
    
    return $text;
}

sub post_load_filter {
    my ($en, $obj) = @_;
    # Break out if we are rebuilding
    require MT::App;
    my $app = MT::App->instance;
    my $ref = ref $app;
    if ($ref eq "MT::App::CMS" && $app && $app->mode eq 'view') {
	my $fltr = $obj->convert_breaks;
	$fltr =~ s/,quicklink//;
	$obj->convert_breaks($fltr);
    }
}

sub pre_save_filter {
    my ($eh,$obj) = @_;
    # add the quicklink filter
    my $fltr = $obj->convert_breaks;
    $obj->convert_breaks("$fltr,quicklink");
}

sub pre_preview_filter {
    my ($eh,$app,$obj) = @_;
    # add the quicklink filter
    my $fltr = $obj->convert_breaks;
    $obj->convert_breaks("$fltr,quicklink");
}


sub quicklink_filter {
    my ($str, $ctx) = @_;
    require AutoLink::Rule;
    my $blog_id = $ctx->var('blog_id');
    my $blog = $ctx->stash('blog');
    if (!$blog && $blog_id) {
        $blog = MT->model('blog')->load($blog_id);
    }
    my @rules = AutoLink::Rule->load({ blog_id => $blog->id });
    my $newstr = process_text($str,\@rules);

    my $app = MT::App->instance;
    my $ref = ref $app;
    return $newstr;
}

1;

__END__
