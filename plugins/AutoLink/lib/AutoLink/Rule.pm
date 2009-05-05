# AutoLink Movable Type Plugin
# Copyright (C) 2004-2008 Byrne Reese

package AutoLink::Rule;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id'          => 'integer not null auto_increment',
	'blog_id'     => 'integer',
        'label'       => 'string(100) not null',
        'pattern'     => 'string(255) not null',
        'regex'       => 'smallint not null',
        'global'      => 'smallint not null',
        'disabled'    => 'smallint not null',
        'case_insensitive' => 'smallint not null',
        'destination' => 'string(255) not null',
    },
    audit => 1,
    indexes => {
        id => 1,
        pattern => 1,
    },
    datasource => 'autolink_rules',
    primary_key => 'id',
});

sub class_label {
    MT->translate("Rule");
}

sub class_label_plural {
    MT->translate("Rules");
}

1;
__END__
