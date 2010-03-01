# AutoLink Movable Type Plugin
# Copyright (C) 2004-2008 Byrne Reese

package AutoLink::CMS;

use strict;

use Carp qw( croak );
use base qw( MT::App );

sub plugin {
    return MT->component('AutoLink');
}

sub id { 'autolink_cms' }

use MT::Util qw( relative_date offset_time offset_time_list epoch2ts ts2epoch format_ts );

sub itemset_delete_rules {
    my ($app) = @_;
    $app->validate_magic or return;

    my @rules = $app->param('id');

    for my $rule_id (@rules) {
        my $rule = MT->model('autolink.rule')->load($rule_id)
          or next;
#        next if $app->user->id != $rule->author_id && !$app->user->is_superuser();
        $rule->remove;
    }

    $app->add_return_arg( rule_removed => 1 );
    $app->call_return;
}
sub itemset_enable_rules {
    my ($app) = @_;
    $app->validate_magic or return;

    my @rules = $app->param('id');

    for my $rule_id (@rules) {
        my $rule = MT->model('autolink.rule')->load($rule_id)
          or next;
#        next if $app->user->id != $rule->author_id && !$app->user->is_superuser();
        $rule->disabled(0);
	$rule->save;
    }

    $app->add_return_arg( rule_enabled => 1 );
    $app->call_return;
}

sub itemset_disable_rules {
    my ($app) = @_;
    $app->validate_magic or return;

    my @rules = $app->param('id');

    for my $rule_id (@rules) {
        my $rule = MT->model('autolink.rule')->load($rule_id)
          or next;
#        next if $app->user->id != $rule->author_id && !$app->user->is_superuser();
        $rule->disabled(1);
	$rule->save;
    }

    $app->add_return_arg( rule_disabled => 1 );
    $app->call_return;
}

sub list_rules {
    my $app = shift;
    my ($params) = @_;
    $params ||= {};

    my $code = sub {
        my ($rule, $row) = @_;

	$row->{id}         = $rule->id;
	$row->{url}        = $rule->destination;
	$row->{pattern}    = $rule->pattern;
	$row->{regex}      = $rule->regex;
	$row->{global}     = $rule->global;
	$row->{case}       = $rule->case_insensitive;
	$row->{new_widnow} = $rule->new_window;
	$row->{blog_id}    = $rule->blog_id;
	$row->{label}      = $rule->label;
	$row->{enabled}    = !$rule->disabled;

	my $uri_short = $rule->destination;
	if (length($uri_short) > 50) {
	    $uri_short =~ s/.*(.{50})$/\1/;
	    $row->{url} = $uri_short;
	}

        my $ts = $row->{created_on};
	my $datetime_format = MT::App::CMS::LISTING_DATETIME_FORMAT();
	my $time_formatted = format_ts( $datetime_format, $ts, $app->blog, 
					$app->user ? $app->user->preferred_language : undef );
        $row->{created_on_relative} = relative_date($ts, time, $app->blog);
        $row->{created_on_formatted} = $time_formatted;
    };

    my $plugin = MT->component('AutoLink');

    $app->listing({
        type     => 'autolink.rule',
        terms    => {
            blog_id => $app->blog->id,
        },
        args     => {
            sort      => 'created_on',
            direction => 'descend',
        },
        listing_screen => 1,
        code     => $code,
        template => $plugin->load_tmpl('list.tmpl'),
        params   => $params,
    });

}

sub edit {
    my $app = shift;
    my ($param) = @_;
    my $q = $app->{query};
    my $blog = MT::Blog->load($q->param('blog_id'));
    
    $param ||= {};
    
    my $rule;
    if ($q->param('rule_id')) {
        $rule = MT->model('autolink.rule')->load($q->param('rule_id'));
    } else {
        $rule = MT->model('autolink.rule')->new();
    }
    
    $param->{blog_id}      = $blog->id;
    $param->{label}        = $rule->label;
    $param->{rule_id}      = $rule->id;
    $param->{pattern}      = $rule->pattern;
    $param->{regex}        = $rule->regex ? 1 : 0;
    $param->{case}         = $rule->case_insensitive;
    $param->{new_window}   = $rule->new_window;
    $param->{global}       = $rule->global;
    $param->{destination}  = $rule->destination;
    return $app->load_tmpl( 'dialog/create.tmpl', $param );
}

sub save {
    my $app = shift;
    my $param;
    my $q = $app->{query};
    my $rule = MT->model('autolink.rule')->load( $q->param('rule_id') );
    unless ($rule) { 
        $rule = AutoLink::Rule->new;
        $rule->disabled(0);
    }
    $rule->blog_id($q->param('blog_id'));
    $rule->label($q->param('label'));
    $rule->pattern($q->param('pattern'));
    $rule->case_insensitive($q->param('case') ? 1 : 0);
    $rule->new_window($q->param('new_window') ? 1 : 0);
    $rule->regex($q->param('regex') ? 1 : 0);
    $rule->global($q->param('global') ? 1 : 0);
    $rule->destination($q->param('url'));
    $rule->save or return $app->error( $rule->errstr );

    my $cgi = $app->{cfg}->CGIPath . $app->{cfg}->AdminScript;
    $app->redirect("$cgi?__mode=autolink_list&blog_id=".$q->param('blog_id')."&rule_saved=1");
}

sub delete {
    my $app = shift;
    my $q = $app->{query};
    my $blog_id = $q->param('blog_id') || 1;
    
    if (!defined($q->param('confirm'))) {
        return confirm_delete($app);
    }
    if ($q->param('confirm') ne 'yes') {
        return list($app);
    }

    my $blog = MT->model('blog')->load($blog_id);
    foreach my $key ($q->param('key')) {
        my $data = MT::PluginData->load({ plugin => 'QuickLink',
                                          key    => $key });
        $data->remove or return $app->error("Error: " . $data->errstr);
    }
    $app->{message} = "Links deleted from QuickList";
    list($app);
}

1;

__END__
