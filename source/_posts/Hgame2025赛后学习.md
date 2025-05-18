---
title: Hgame2025赛后学习
date: 2025-03-07 16:45:22
updated: 2025-05-06 19:56:52
tags:
categories:
keywords:
description:
top_img:
comments:
cover:
toc:
toc_number:
toc_style_simple:
copyright:
copyright_author:
copyright_author_href:
copyright_url:
copyright_info:
mathjax:
katex:
aplayer:
highlight_shrink:
aside:
abcjs:
noticeOutdate:
---

# Hgame2025赛后学习

​	在发现自己的网络安全知识非常的低下后，也就不再现在ctf这条赛道上进行苦卷了，更多地把他看作是各种高级封装开发外的对计算机技术底层的一种兴趣认知。所以也不太好意思说这是我的赛后总结, 毕竟也就做出来那么两道题, 其他的就根本不行了, 可见和众多师傅相比我的计算机水平十分的有限, 所以就把这比赛当作是认知新技术的一种契机了.

## web

### BandBomb

#### 做题经历

​	第一次尝试web的题, 最终还是没有做出来. 通过阅读给出的服务器代码, 可以知道有一个接口`/rename`在后面的使用中应该会有用处, 推测可以根据请求对相关文件进行更改. 由于做misc的经验, 所以我以为会有一个相关的flag文件放在服务器上, 需要更改使其进行显示. 但是由于没有学过`ejs`的技术, 所以完全不知道这道题的用意了.

​	同时, 在为运行中的web服务设置环境变量也属于是在我的技术水平之外了.

#### 相关细节

​	通过阅读服务的代码, 可以知道, template的名字为`motis`同时, 是处在默认的ejs文件夹下的, 所有做题思路是自己编写相关的服务器文件, 然后通过`/rename`接口对原来的服务器文件进行替换, 自己编写的服务器系统需要读取服务器运行设置的flag环境变量, 将其返回即可.

```js
//题目提供的服务器源代码
const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const app = express();

app.set('view engine', 'ejs');

app.use('/static', express.static(path.join(__dirname, 'public')));
app.use(express.json());

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = 'uploads';
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir);
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  }
});

const upload = multer({ 
  storage: storage,
  fileFilter: (_, file, cb) => {
    try {
      if (!file.originalname) {
        return cb(new Error('无效的文件名'), false);
      }
      cb(null, true);
    } catch (err) {
      cb(new Error('文件处理错误'), false);
    }
  }
});

app.get('/', (req, res) => {
  const uploadsDir = path.join(__dirname, 'uploads');
  
  if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir);
  }

  fs.readdir(uploadsDir, (err, files) => {
    if (err) {
      return res.status(500).render('mortis', { files: [] });
    }
    res.render('mortis', { files: files });  //将读取到的参数放到“mortis”的模板中
  });
});

app.post('/upload', (req, res) => {
  upload.single('file')(req, res, (err) => {
    if (err) {
      return res.status(400).json({ error: err.message });
    }
    if (!req.file) {
      return res.status(400).json({ error: '没有选择文件' });
    }
    res.json({ 
      message: '文件上传成功',
      filename: req.file.filename 
    });
  });
});

app.post('/rename', (req, res) => {
  const { oldName, newName } = req.body;
  const oldPath = path.join(__dirname, 'uploads', oldName);
  const newPath = path.join(__dirname, 'uploads', newName);

  if (!oldName || !newName) {
    return res.status(400).json({ error: ' ' });
  }

  fs.rename(oldPath, newPath, (err) => {
    if (err) {
      return res.status(500).json({ error: ' ' + err.message });
    }
    res.json({ message: ' ' });
  });
});

app.listen(port, () => {
  console.log(`服务器运行在 http://localhost:${port}`);
});

```



