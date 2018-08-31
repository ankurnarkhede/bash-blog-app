#!/usr/bin/env bash

#task

#    blog.sh will return the name of your application
#    blog.sh --help will list help text and commands available

#    blog.sh post add "title" "content" will add a new blog a new blog post with the specified title and content
#    blog.sh post add "title" "content" --category "cat-name" will add a new blog post with the specified title, content and assign a category to it. If the category doesn’t exist, it will first be created.
#    blog.sh post list will list all blog posts
#    blog.sh post search "keyword" will list all blog posts where “keyword” is found in the title and/or content

#    blog.sh category add "category-name" will create a new category
#    blog.sh category list will list all current categories
#    blog.sh category assign <post-id> <cat-id> will assign the specified category to a post


BLOG_DB="./blog.db"

print_help(){

    printf "blog.sh will return the name of your application\n"
    printf "blog.sh --help will list help text and commands available\n"
    printf "blog.sh post add "title" "content" will add a new blog a new blog post with the specified title and content\n"
    printf "blog.sh post add "title" "content" --category "cat-name" will add a new blog post with the specified title, content and assign a category to it. If the category doesn’t exist, it will first be created.\n"
    printf "blog.sh post list will list all blog posts\n"
    printf "blog.sh post search "keyword" will list all blog posts where “keyword” is found in the title and/or content\n"
    printf "blog.sh category add "category-name" will create a new category\n"
    printf "blog.sh category list will list all current categories\n"
    printf "blog.sh category assign <post-id> <cat-id> will assign the specified category to a post\n"

}

invalid_args(){
    printf "INVALID arguments passed\nPass --help for help\n"

}

#post functions
post_add(){
    echo "Inside post_add fun, args= $@\n"
    category_id=$(sqlite3 $BLOG_DB "SELECT id FROM category WHERE category = '$3';")

    if [ -z "$category_id" ]; then
        printf "category empty\n"
        category_add $3
        category_id=$(sqlite3 $BLOG_DB "SELECT id FROM category WHERE category = '$3';")
    fi

    printf "CAT ID= $category_id\n"
    sqlite3 $BLOG_DB "INSERT INTO posts (title, content,category) VALUES('$1', '$2', '$category_id');"
    printf "Post added Successfully!\n"

}

post_list(){


}

#category functions
category_add(){
    sqlite3 $BLOG_DB "INSERT into category (category)VALUES ('$1');"
    printf "Category $1 added successfully!\n"

}


printf "$#\n"

#    blog.sh will return the name of your application
if [ $# == 0 ]; then
    printf "Bash Blogging App\n"
fi


#reading the args

if [ $1 == "--help" ]; then
    printf "=============PRINTING HELP DESCRIPTION==============\n"
    print_help

elif [ $1 == "post" ]; then
    printf "Inside POST\n"
    shift
    printf "$1 $2 $3\n"

    case $1 in
        add)
            if [ $# -ge 3 ]; then
                printf "Adding post\n"
                post_add $2 $3 $5

                else
                    printf "in post, default\n"
            fi
            ;;

        list)
            printf "in list!\n"
            ;;

        search)
            printf "in search!\n"
            ;;

        *)
#                default case
            invalid_args
            ;;
    esac


elif [ $1 == "category" ]; then
    printf "Inside CATEGORY\n"
    shift

    case $1 in
        add)
            printf "adding category!\n"
            if [ $# == 3 ]; then
                printf "Adding category\n"

                else
                    printf "in post, default\n"
            fi
            ;;

        list)
            printf "in list!\n"
            ;;

        assign)
            printf "in assign!\n"
            ;;

        *)
#                default case
            invalid_args
            ;;
    esac



else
   invalid_args
fi

