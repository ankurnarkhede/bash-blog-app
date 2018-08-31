# bash-blog-app
A Command Line Interface for blog written in Bash


**Getting Started**

###Posts
Add Post
`$ bash blog.sh post add "title" "content" --category "category"`

List all Posts
`$ bash blog.sh post list`

Search for a post
`$ bash blog.sh post search "keyword"`


###Categories
Add a Category
`$ bash blog.sh category add "category_name"`

List all Categories
`$ bash blog.sh category list`

Assign Category to a specific Post
`$ bash blog.sh category assign <post-id> <cat-id>`