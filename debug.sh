#!/bin/bash
#cd ~/Desktop/wp/$1

# wp post create --post_type=page --post_title='Accueil' --post_status=publish
# wp post create --post_type=page --post_title='Blog' --post_status=publish
# wp post create --post_type=page --post_title='Contact' --post_status=publish
# wp post create --post_type=page --post_title='Mentions Légales' --post_status=publish

# wp option update show_on_front page
# wp option update page_on_front 15
# wp option update page_for_posts 16

# wp option update category_base /theme
# wp option update tag_base /sujet


# acfkey="b3JkZXJfaWQ9MzI1Mjd8dHlwZT1kZXZlbG9wZXJ8ZGF0ZT0yMDE0LTA3LTA3IDEzOjMxOjU1"
# acfurl="http://connect.advancedcustomfields.com/index.php?p=pro&a=update&k=${acfkey}"
# wp plugin install ${acfurl}

#wp theme install "https://bitbucket.org/maximebj/wordpress-zero-theme/get/dcbb90b8721a.zip" --activate

#git clone git@bitbucket.org:maximebj/wordpress-zero-theme.git

# cd wp-content/themes/
# git clone git@bitbucket.org:smoothiecreative/wordpress-base-theme.git
# wp theme activate wordpress-base-theme


#subl 'wp-content/themes/'

# cd wp-content/themes/
# #git clone git@bitbucket.org:smoothiecreative/wordpress-base-theme.git
# cd prout

# open .

echo "Arg 1 : $1"
echo "Arg 2 : $2"

# mv wordpress-base-theme 'prout'
# wp theme activate prout