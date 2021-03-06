#!/bin/bash
# Wippy (｡◕‿◕｡)
# Automatize your WordPress installation
#
# By @maximebj (maxime@smoothie-creative.com)
#
# *** Recommended for Lazy people like me ***
#
# How to launch wippy ?
# bash wippy.sh sitename "My WP Blog"
# $1 = folder name & database name
# $2 = Site title

# Stop on error
set -e

#  ===============
#  = Fancy Stuff =
#  ===============
# not mandatory at all

# colorize and formatting command line
green='\x1B[0;32m'
cyan='\x1B[1;36m'
blue='\x1B[0;34m'
grey='\x1B[1;30m'
red='\x1B[0;31m'
bold='\033[1m'
normal='\033[0m'

# Jump a line
function line {
  echo " "
}

# Wippy has something to say
function bot {
  line
  echo -e "${blue}${bold}(｡◕‿◕｡)${normal}  $1"
}


#  ==============================
#  = The show is about to begin =
#  ==============================

# Welcome !
bot "${blue}${bold}Bonjour ! Je suis Wippy.${normal}"
echo -e "         Je vais installer WordPress pour votre site : ${cyan}$2${normal}"

# CHECK :  Directory doesn't exist
# go to wordpress installs folder
cd ~/Desktop

# check if provided folder name already exists
if [ -d $1 ]; then
  bot "${red}Le dossier ${cyan}$1${red}existe déjà${normal}."
  echo "         Par sécurité, je ne vais pas plus loin pour ne rien écraser."
  line

  # quit script
  exit 1
fi

# create directory
bot "Je crée le dossier : ${cyan}$1${normal}"
mkdir $1
cd $1

# Download WP
bot "Je télécharge WordPress..."
wp core download --locale=fr_FR --force

# check version
bot "J'ai récupéré cette version :"
wp core version

# create base configuration
bot "Je lance la configuration :"
wp core config --dbname=$1 --dbuser=root --dbpass=root --skip-check --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP

# Create database
bot "Je crée la base de données :"
wp db create

# Generate random password
passgen=`head -c 10 /dev/random | base64`
password=${passgen:0:10}

# local url and admin login
url="http://"$1":8888/"
admin="smoothie-$1"

# launch install
bot "et j'installe !"
wp core install --url=$url --title="$2" --admin_user=$admin --admin_email=maxime@smoothie-creative.com --admin_password=$password

# Plugins install
bot "J'installe les plugins à partir de la liste des plugins :"
while read line
do
    wp plugin install $line --activate
done < ~/Dropbox\ \(Smoothie\ Creative\)/Smoothie\ Creative/Développement/wippy/plugins.txt

# Download ACF Pro
curl -L -v 'http://connect.advancedcustomfields.com/index.php?p=pro&a=download&k=b3JkZXJfaWQ9MzI1Mjd8dHlwZT1kZXZlbG9wZXJ8ZGF0ZT0yMDE0LTA3LTA3IDEzOjMxOjU1' | tar -xf- -C wp-content/plugins/
wp plugin activate advanced-custom-fields-pro

# Download from private git repository
# bot "Je télécharge notre thème Smoothie Framework :"
# cd wp-content/themes/
# git clone git@bitbucket.org:smoothiecreative/wordpress-base-theme.git
# mv wordpress-base-theme $1   # rename folder
# wp theme activate $1

# Create standard pages
bot "Je crée les pages habituelles (Accueil, blog, contact...)"
wp post create --post_type=page --post_title='Accueil' --post_status=publish
wp post create --post_type=page --post_title='Blog' --post_status=publish
wp post create --post_type=page --post_title='Contact' --post_status=publish
wp post create --post_type=page --post_title='Mentions Légales' --post_status=publish

# Create fake posts
bot "Je crée quelques faux articles"
curl http://loripsum.net/api/5 | wp post generate --post_content --count=5

# Change Homepage
bot "Je change la page d'accueil et la page des articles"
wp option update show_on_front page
wp option update page_on_front 3
wp option update page_for_posts 4


# Menu stuff
bot "Je crée le menu principal, assigne les pages, et je lie l'emplacement du thème : "
wp menu create "Menu Principal"
wp menu item add-post menu-principal 3
wp menu item add-post menu-principal 4
wp menu item add-post menu-principal 5
#wp menu location assign menu-principal main-menu


# Misc cleanup
bot "Je supprime Hello Dolly, les thèmes de base et les articles exemples"
wp post delete 1 --force # Article exemple - no trash. Comment is also deleted
wp post delete 2 --force # page exemple
wp plugin delete hello
wp theme delete twentytwelve
wp theme delete twentythirteen
wp theme delete twentyfourteen
wp option update blogdescription ''

# Permalinks to /%postname%/
bot "J'active la structure des permaliens"
wp rewrite structure "/%postname%/" --hard
wp rewrite flush --hard

# cat and tag base update
wp option update category_base theme
wp option update tag_base sujet


# Get our base WP Projet gitignore file from our repo
# TODO

# Git project
bot "Je Git le projet :"
cd ../..
git init    # git project
git add -A  # Add all untracked files
git commit -m "Initial commit"   # Commit changes


# Restart Mamp Apache
# TODO

# Open the stuff
#bot "Je lance le navigateur, Sublime Text et le finder."

# Open in browser
#open $url
#open "${url}wp-admin"

# Open in Sublime text
#cd wp-content/themes
#subl $1

# Open in finder
#cd $1
#open .

# Copy password in clipboard
echo $password | pbcopy


# That's all ! Install summary
bot "${green}L'installation est terminée !${normal}"
line
echo "URL du site:   $url"
echo "Login admin :  admin$1"
echo -e "Password :  ${cyan}${bold} $password ${normal}${normal}"
line
echo -e "${grey}(N'oubliez pas le mot de passe ! Je l'ai copié dans le presse-papier)${normal}"

line
bot "à Bientôt !"
line
line
