#
# README.txt file for the AutoLink Movabletype Plugin
# 

ABOUT AUTOLINK

AutoLink provides users with a way of creating a list of "hot words."
Whenever these words appear in a post, they are automatically linked to
a designated URL. For example, if you were to frequently write about
Movable Type, and anytime you mention the phrase "Movable Type" in a
post you want it to be linked to http://www.movabletype.org/ without
having to enter the link manually. This plugin will do that for you.

More advanced users could use AutoLink to setup linking rules that will
turn Wiki formatted words into links into their internal/external wiki.

PREREQUISITES

Prior to installation, the following requirements must be satisfied:

  * User has MovableType 4.1 or later installed
    - it could work on 4.0, but it has not been tested

INSTALLATION

  1. Unpack the ConfigAssistant archive.
  2. Copy the contents of ConfigAssistant/plugins into /path/to/mt/plugins/

You will know if AutoLink is installed properly if you can see AutoLink 
listed under your list of Active Plugins.

ABOUT AUTOLINK RULES

Users manage how AutoLink is to convert strings, phrases and patterns
into linkified text through a set of "rules." Each rule has the following
properties:

* Label - a human readable description of the rule and its intention
* Pattern - the string to convert into a link
* Destination URL - the URL that the pattern will be linked to
* Regular Expression? - Process the pattern specified as a regular
  expression, otherwise process it is a simple string or phrase 
* Link all occurrences? - Link all occurrences of the pattern, or just
  the first occurrence.
* Case insensitive? - Make the pattern case insensitive.

ACCESSING THE INTERFACE

Each blog in your installation of Movable Type is allowed to manage
its own unique set of AutoLink rules.

You can edit your list of AutoLink rules by clicking "AutoLink Rules" 
from the Manage menu in Movable Type.

SUPPORT

Please post your bugs, questions and comments to the AutoLink project
homepage:

  http://www.majordojo.com/projects/autolink.php

RESOURCES

  AutoLink:
  http://www.majordojo.com/projects/autolink.php

  Movable Type:
  http://www.movabletype.org/

LICENSE

AutoLink is licensed under the GPL.
