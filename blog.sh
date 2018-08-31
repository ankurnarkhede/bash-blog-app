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
    printf "Listing all posts\n"
    sqlite3 blog.db "SELECT p.id,p.title, p.content, c.category FROM posts as p LEFT OUTER JOIN category as c ON p.category=c.id;"> output.txt


    while IFS='|' read val1 val2 val3 val4 ;do

        if [ -z "$val4" ]; then
            val4="null"
        fi

        printf "\t%-10s : %s\n" "Id" $val1
        printf "\t%-10s : %s\n" "Title" $val2
        printf "\t%-10s : %s\n" "Content" $val3
        printf "\t%-10s : %s\n" "Category" $val4
        printf "=======================================\n"

    done < output.txt

}

post_search(){
    printf "Search results for '$1':\n"
    sqlite3 blog.db "SELECT p.id,p.title, p.content, c.category FROM posts as p
                        LEFT OUTER JOIN category as c ON p.category=c.id
                        WHERE p.title LIKE '%$1%' OR p.content LIKE '%$1%';"> output.txt


    while IFS='|' read val1 val2 val3 val4 ;do

        if [ -z "$val4" ]; then
            val4="null"
        fi

        printf "\t%-10s : %s\n" "Id" $val1
        printf "\t%-10s : %s\n" "Title" $val2
        printf "\t%-10s : %s\n" "Content" $val3
        printf "\t%-10s : %s\n" "Category" $val4
        printf "=======================================\n"

    done < output.txt


}

#category functions
category_add(){
    sqlite3 $BLOG_DB "INSERT into category (category)VALUES ('$1');"
    printf "Category $1 added successfully!\n"


}

category_list(){
    printf "Listing all Categories:\n"
    sqlite3 blog.db "SELECT id,category FROM category;"> output.txt


    while IFS='|' read val1 val2 ;do
        printf "\t $val1. $val2\n"

    done < output.txt

}

category_assign_to_post(){
    sqlite3 blog.db "UPDATE posts SET category='$2' WHERE id='$1';"

    category=$(sqlite3 $BLOG_DB "SELECT category FROM category WHERE id = '$2';")
    post_title=$(sqlite3 $BLOG_DB "SELECT title FROM posts WHERE id = '$1';")

    printf "Category '$category' assigned to post '$post_title'\n"


}


#main program

#printing name of application
if [ $# == 0 ]; then
    printf "Bash Blogging App\n"
fi

#reading the args
if [ $1 == "--help" ]; then
    print_help

elif [ $1 == "post" ]; then
    shift
    printf "$1 $2 $3\n"

    case $1 in
        add)
            if [ $# -ge 3 ]; then
                post_add $2 $3 $5

                else
                    invalid_args
            fi
            ;;

        list)
            post_list
            ;;

        search)
            post_search $2
            ;;

        *)
#           default case
            invalid_args
            ;;
    esac


elif [ $1 == "category" ]; then
    shift

    case $1 in
        add)
            category_add $2
            ;;

        list)
            category_list
            ;;

        assign)
            category_assign_to_post $2 $3
            ;;

        *)
#           default case
            invalid_args
            ;;
    esac

else
   invalid_args
fi

