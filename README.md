# About AutoLink

AutoLink provides users with a way of creating a list of "hot words."
Whenever these words appear in a post, they are automatically linked to
a designated URL. For example, if you were to frequently write about
Movable Type, and anytime you mention the phrase "Movable Type" in a
post you want it to be linked to http://www.movabletype.org/ without
having to enter the link manually. This plugin will do that for you.

More advanced users could use AutoLink to setup linking rules that will
turn Wiki formatted words into links into their internal/external wiki.

# Prerequisites

Prior to installation, the following requirements must be satisfied:

* User has MovableType 4.1 or later installed

# Installation

This plugin is installed [just like any other Movable Type Plugin](http://www.majordojo.com/2008/12/the-ultimate-guide-to-installing-movable-type-plugins.php).

# Usage 

## About AutoLink Rules

Users manage how AutoLink is to convert strings, phrases and patterns
into linkified text through a set of "rules." Each rule has the following
properties:

* **Label** - a human readable description of the rule and its intention
* **Pattern** - the string to convert into a link
* **Destination URL** - the URL that the pattern will be linked to
* **Regular Expression?** - Process the pattern specified as a regular
  expression, otherwise process it is a simple string or phrase 
* **Link all occurrences?** - Link all occurrences of the pattern, or just
  the first occurrence.
* **Case insensitive?** - Make the pattern case insensitive.
* **Open in New Window?** - Open the generated link in a new window?

## Accessing the Interface

Each blog in your installation of Movable Type is allowed to manage
its own unique set of AutoLink rules.

You can edit your list of AutoLink rules by clicking "AutoLink Rules" 
from the Manage menu in Movable Type.

## Designer Tips and CSS

All generated links are automatically assigned a class of "autolink."
Designers can then create CSS class selectors to style links generated
by AutoLink to differentiate them from other links found on the site.

# Support

Please submit bug reports to our bug tracking system:

* Via the web: https://endevver.lighthouseapp.com/projects/47575-autolink/tickets
* Via email: ticket+endevver.47575-s6ytjtqz@lighthouseapp.com

# License

AutoLink is licensed under the GPLv2.
