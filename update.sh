unzip ./blog.zip -d ./source/_post/

hexo clean
hexo g

cp -rf ./public/* /www/wwwroot/myBlog
echo "完成更新"