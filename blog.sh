#!/usr/bin/env bash

source functions.sh
BLOG_DB="./blog.db"


print_help(){
    printf "\n"
    printf "Post Commands:\n"
    printf "\t%-10s : %s\n" "Usage" "$ bash blog.sh post [Command] [arguments]"

    printf "\n\t%-10s : %s\n" "add" "Create Post"
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh post add \"title\" \"content\" --category \"category_name\""
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh post add \"title\" \"content\""

    printf "\n\t%-10s : %s\n" "list" "List all Posts"
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh post list"


    printf "\n\t%-10s : %s\n" "search" "Search a for a post"
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh post search \"text\""


#    category commands
    printf "\n\nCategory Commands:\n"
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh category [Command] [arguments]"

    printf "\n\t%-10s : %s\n" "list" "List all Categories"
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh category list"

    printf "\n\t%-10s : %s\n" "assign" "Assign a category to a post"
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh category assign <post-id> <cat-id>"

    printf "\n\t%-10s : %s\n" "add" "Add a category"
    printf "\t%-10s : %s\n" "Usage:" "$ bash blog.sh category add \"category_name\""

    printf "\n\n"


}

invalid_args(){
    printf "INVALID arguments passed\nUse 'bash blog.sh --help' for help\n"

}

#post functions
post_add(){

    if [ "$3" ]; then
        category_id=$(sqlite3 $BLOG_DB "SELECT id FROM category WHERE category = '$3';")

        if [ -z "$category_id" ]; then
            category_add $3

        fi
    fi



    category_id=$(sqlite3 $BLOG_DB "SELECT id FROM category WHERE category = '$3';")
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
    printf "Id|Category\n"> output.txt
    sqlite3 blog.db "SELECT id,category FROM category;">> output.txt


    printTable '|' "$(cat output.txt)"

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
    exit 0
fi

#reading the args
if [[ $1 == "--help" ]]; then
    print_help

elif [[ $1 == "post" ]]; then
    shift

    case $1 in
        add)
            if [ $# -ge 3 ]; then
                post_add "$2" "$3" "$5"

                else
                    invalid_args
            fi
            ;;

        list)
            post_list
            ;;

        search)
            post_search "$2"
            ;;

        *)
#           default case
            invalid_args
            ;;
    esac


elif [[ $1 == "category" ]]; then
    shift

    case $1 in
        add)
            category_add "$2"
            ;;

        list)
            category_list
            ;;

        assign)
            category_assign_to_post "$2" "$3"
            ;;

        *)
#           default case
            invalid_args
            ;;
    esac

else
   invalid_args
fi

