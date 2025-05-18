---
title: Leetcode&洛谷刷题记录与思考
date: 2025-05-06 18:47:42
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

# Leetcode&&洛谷刷题记录与思考

## p 7517

题目链接：

[](https://www.luogu.com.cn/problem/solution/P7517)

对于第一篇题解的理解。

···

```c++
#include<bits/stdc++.h>
#define ll long long
#define il inline
using namespace std;
const int N=5e5+10;
int read(){//没有多大用的快读
    int f=1,s=0;
    char x=getchar();
    while(x<'0'||x>'9'){
        if(x=='-') f=-1;
        x=getchar();
    }
    while(x>='0'&&x<='9'){
        s=s*10+x-'0';
        x=getchar();
    }
    return f*s;
}
int a[N],b[N];//b即为桶
int main(){
    int n=read();
    for(int i=1;i<=n;i++){
        a[i]=read();
        for(int j=1;j*j<=a[i];j++){
            if(a[i]%j!=0) continue;//关键判断
            int ans1=j,ans2=a[i]/j;
            b[ans1]++;
            if(ans1!=ans2)//特判
                b[ans2]++;
        }
    }
    ll ans=0;//爆int警告
    for(int i=1;i<=n;i++)
        ans+=(ll)b[a[i]]-1;//累加，减一是减去自己的贡献
    cout<<ans;
    return 0;
}
```

···

其中有他自己创建的读取函数，目前我并不知道这样的读取函数对于直接使用系统自带函数能够提速多少，所以目前不予讨论. 

这篇题解的思路在于直接将每个输入的数的因数直接统计出来,在b桶中计数, a中存储的是用户输入的结果. 最后再将用户输入的结果中的数所对应的桶中的结果倒出来, 同时减去来自自己出现时的那一次` 如果是i=j可以出现的情况应该就不用了`. 这样每次用户输入的数需要判断
$$
O(\sqrt{a_i})
$$
第二种方法:

```c++
#include<bits/stdc++.h>
#define ll long long
#define il inline
using namespace std;
const int N=5e5+10;
int read(){
    int f=1,s=0;
    char x=getchar();
    while(x<'0'||x>'9'){
        if(x=='-') f=-1;
        x=getchar();
    }
    while(x>='0'&&x<='9'){
        s=s*10+x-'0';
        x=getchar();
    }
    return f*s;
}
int a[N],b[N];
int main(){
    int n=read();
    for(int i=1;i<=n;i++)
    	b[read()]++;
    ll ans=0;
    for(int i=1;i<=N;i++){
    	for(int j=2;i*j<=N;j++)
    		ans+=b[i]*b[i*j];
    	ans+=b[i]*(b[i]-1);
	}
    cout<<ans;
    return 0;
}
```

这次通过的是将尽可能的用户输入的数的倍数全部都进行计数. 如果用户输入的数的倍数曾经在用户输入的数据中, 就相当于可以组成一个数对. 不存在的话, 自然相应的数的次数为0, 最终累成和累加的结果就是0. 但是这样的操作,不经让人觉得速度并没有快多少, 应为都要将所有的数据判断一遍, 其中会有很多的含零的数据, 同时这对内存的消耗也很大.



### 总结

对于这道题, 看基本上的解题思路都是直接通过设置桶, 然后直接统计倍数. 这道题的数据都是`a_i<=5e5` 所以直接将最大定位.

### 自己根据学习写的代码

```C
#include<stdio.h>
#include<string.h>
const long long Maxn=5e5+10;
int main()
{
    int n;
    scanf("%d",&n);
    long long a[Maxn];
    memset(a,0,sizeof(a));
    
    for(long long i=0;i<n;i++)
    {
        long long temp;
        scanf("%lld",&temp);
        a[temp]++;
    }
    long long ans=0;
    for(long long i=1;i<Maxn;i++){
        ans+=a[i]*(a[i]-1);
        for(long long j=2*i;j<Maxn;j+=i){
            ans+=a[i]*a[j];
        }
    }
    
    printf("%lld",ans);
    return 0;
        
}
```

## p 2701

[洛谷](https://www.luogu.com.cn/problem/P2701)

根据提供的题解是通过动态规划进行解答. 

对于动态规划, 首先, 能够进行动态规划的题目首先可以满足暴力枚举, 但是由于数据量较大, 时间消耗过多. 其次, 可以根据节点, 会出现重复搜索或枚举,  将这部分的重复枚举进行删除或者记录, 达到省去的操作, 就可以称作是动态规划.  ==仅代表个人理解==  .

对于这道题, 选取每一个点作为起点向别处延伸, 很明显可以通过暴力枚举进行解答, 同时, 通过不同的点进行容易想到, 会有很多重复, 所以就可以通过动态规划进行解题.

由于面积的延伸是正方形,倘若任意一点向想对边进行延伸,即 都需要考虑他周围的点,  

```c
#include<stdio.h>
int min_3(int ,int ,int);
int main()
{
    int n,t;
    scanf("%d %d",&n,&t);
    int a[n][n],b[n][n];
    for(int i=0;i<n;i++)
        for(int j=0;j<n;j++)
            a[i][j]=1;

    for(int i=0;i<t;i++)
    {
        int x,y;
        scanf("%d %d",&x,&y);
        a[x-1][y-1]=0;
    }
    for(int i=0;i<n;i++)
        for(int j=0;j<n;j++)
            b[i][j]=a[i][j];
    //到这为止已经将所有的数据进行了初始化。
    //同时，此时的为0是第一行开始，0表示此处有树
    //当以点为右下角,此处同时可以代表就是此处可以达到的最大面积

    //将每一个点代表的正方形可视化，或者是略加思考，可以的到每个点与周围点的关系

   for(int i=1;i<n;i++)
        for(int j=1;j<n;j++)
            if(a[i][j])
                b[i][j]+=min_3(b[i-1][j-1],b[i][j-1],b[i-1][j]);    //不要忘记，只有当前的区域是没有树的才可能作为一个区域的右下角。

    int max=0;
    for(int i=0;i<n;i++)
        for(int j=0;j<n;j++)
            if(b[i][j]>max)
                max=b[i][j];
    printf("%d",max);
    return 0; 
}

int min_3(int a,int b,int c)
{
    if(a<b)
        if(a<c)
            return a;
        else
            return c;
    else
        if(b<c)
            return b;
        else
            return c;
}

```

还是要考虑到的是，如何实现动态规划问题。关键在于如何找出者这之间的关系。

## p 2678

[跳石头](https://www.luogu.com.cn/problem/P2678)

通过思考题目可以知道，如果是通过暴力的方法进行解答，需要每次都找到最小的那段距离，然后再将最小的那段距离加到其相邻的两端距离中最小的那一段距离中去，然后再多次重复此方法，知道达到搬移石头的次数用尽。

很明显，这样的算法思路十分简单，但是遇到数据量大的题目时就略显费劲，先寻找最小的值为N，在判断最小值附近的值，这样的操作要做N遍，所以这是一个 O( n^2^ )的算法。

对于题解中大佬给出的二分答案法，我一开始并没有想明白对于一个无法进行排序的距离数组，如何使用需要有序为前提的二分查找. 但是通过阅读代码发现, 其中, 解题人的思路并非是将搬移次数作为了循环条件, 而是将搬移次数M当做了一个判断二分答案是否有效的条件. 其思路是, ==如果存在一个最大的最短距离为X,那么很明显, 其他的任何一段距离必定大于等于这段最短距离== . 

所以, 更具解题人的思路, 只需要查找在最长距离中的能够满足搬运次数少于或等于M次的x的最大值就行了~~当然其实应该不会存在有小于的情况, 不然的话再搬一次不就有新的最大最小距离了吗~~ ,而这个答案明显一定在这之中,当然也可能会包括两端. 对于每个差找到的值, 判断如果需要达到这个查找值,对于当前数组所需要搬运的次数, 如果大于了M次的话, 就说明是太大, 将右边左移, 如果是小于M次就是将左边界右移,应为说明还可以有更大的距离.(其实,这样的算法,同样也会造成很多的数据其实不用算的,毕竟有些数据, 不可能是当前的这个数组能够组成的数据,但是, 在对于巨量的数据来说, 这多出来的计算量, 可能还没有暴力一个节点循环一遍计算量来得多 :cry: )



## 14、最长公共前缀

```c
int SearchForMinString(char** strs, int strsSize) {
    int minsize = strlen(strs[0]);  //初始化最小的长度为第一个字符串的长度
    for (int i = 1; i < strsSize; i++) {
        if (strlen(strs[i]) < minsize)  //如果有字符串的长度小于就取最小的
            minsize = strlen(strs[i]);
    }
    return minsize;
}

char* longestCommonPrefix(char** strs, int strsSize) {
    int minsize = SearchForMinString(strs, strsSize);   //得到最小的字符串长度
    char* answer = (char*)malloc(sizeof(char) * minsize+1);
    memset(answer,0,sizeof(char) * minsize+1);
    int answersize = 0;
    for (int i = 0; i < minsize; i++) {
        for (int j = 1; j < strsSize; j++) {
            if (strs[j][i] != strs[0][i]) //有不一样的就直接返回答案
                return answer;
        }
        answer[answersize] = strs[0][i]; 
        answersize++;
        //说明所有的字符串该为位字符一样，将其赋值到结果的字符串中
    }
    return answer;
}
```

对于其中的字符串的malloc应用, 定要记住字符串结尾有一个`\0`, 但同时,`strlen`函数不会将这个计入字符长度内, 所以直接用这样的到的字符长度去创建一个字符串会导致最后一个`\0`消失, 导致构不成一个字符串. 

与此同时, 对于malloc其分配的地址空间并不会直接给你初始化好, 所以建议搭配memset一起使用, 同时容易记住申请空间的大小.

## 11、盛水最多的容器

这道题，其实就是现实中的短板效应。任意选择的两个板能够盛水容量取决于最短的板. 

对于这道题直接进行暴力求解非常简单. 但是对于一些测试用例会有超时的可能.

对于得到的木板数组处于无序状态,  对于任何的一个组合, 两端的木板选择只有两种. 假设从两端开始选取, 如果将两端任意一段的木板移动, 如果移动长版, 那么, 不论移动后的到的木板长度比原来大, 还是比原来小, 由于短板效应不会变, 但是底边必定变小, 所以选择的是的到的容积必定变小. 所以每次移动, 每次移动短板, 才能够是短板的长度进行变化. 这样的行为,可以一减小一定计算量.

```c
int maxArea(int* height, int heightSize) {
    int head,tail;
    head=0;tail=heightSize-1;
    int maxCapacity=(height[head]<height[tail]?height[head]:height[tail])*(tail-head);
    while(head!=tail)
    {
        if(height[head]>height[tail])
            tail--;
        else
            head++;
        int temp;
        temp=(height[head]<height[tail]?height[head]:height[tail])*(tail-head);
        if(temp>maxCapacity)
            maxCapacity=temp;
    }
    return maxCapacity;
}
```

## 209、长度最小的子数组

### 解法一、滑动窗口解法

对于滑动窗口来说, 本题要求的子数组连续, 所以可以想象成一个窗口进行滑动. 如果该窗口是不变的话, 那么就需要每次对窗口的大小进行调整, 将窗口的大小从1~numsSize进行尝试, 显然,这样的尝试只比O(n2)暴力搜索快一点. 无法在时间限度内完成.

直接从小到大的对窗口进行增大, 存在的问题就是, 会有很多的较小的窗口其实没有计算的必要. 如果使用的是动态大小的窗口的话,可以对此进行一定的减少计算.

先逐步的扩大窗口,直到, 窗口中的数能够直接达到target, 然后再考虑是否对窗口中的数进行出队操作.(对于数组前面的数来说, 必须要是窗口达到当前的大小才能够达到target所以, 应去除窗口前面的数, 看看后面的数有没有可能.) 对窗口中的数进行出队, 当窗口内数的和,小于target的时候, 这时, 就当前的子数组的子数组长度+1的长度, 就是当前子数组能到达到的最小长度, 然后再向后进行查找.

```c
// 纯粹的窗口会导致许多小窗口的无谓计算, 尤其是当target和numsSize较大的时候

int minSubArrayLen(int target, int* nums, int numsSize) {
    int windowlenth=1;
    while(windowlenth<=numsSize){
        for(int i=0;i<=numsSize-windowlenth;i++){
            int sum=0;
            for(int j=i;j-i<windowlenth;j++){
                sum+=nums[j];
            }
            if(sum>=target){
                return windowlenth;
            }
        }
        windowlenth++;
    }
    return 0;
}

//通过动态窗口的大小进行搜索,先找到一个能够达到target的子数组

int minSubArrayLen(int target, int* nums, int numsSize) {
    int queue[numsSize],head,tail;
    int queuesum=0;
    int ans=numsSize+1;
    head=tail=0;
    for(int i=0;i<numsSize;i++){

        //进行入队操作同时统计队内和
        int temp_ans;
        queue[tail]=nums[i];
        tail++;
        queuesum+=nums[i];

        //达到target的时候就从头出队
        if(queuesum>=target){

            //将能够缩小的全部出队
            while(queuesum>=target){
                queuesum-=queue[head];
                head++;
            }


            temp_ans=tail-head+1;
            if(ans>temp_ans)
                ans=temp_ans;
        }
    }
    if (ans == numsSize+1)
        return 0;
    return ans;
}
```



## p1002

[过河卒](https://www.luogu.com.cn/problem/P1002)

其实就是经典动态规划，需要想清楚，几个状态，通过状态的转移找到公式，然后根据公式进行推理即可。

## p1004

[方格取数](https://www.luogu.com.cn/problem/P1004)

通过我的思考，也是动态规划根据题目的意思，但是，这次需要遍历两次，需要在第一次的时候，将取到的数置零。让后再进行第二次遍历，进行同样的操作。但是需要进行。但是对于一个直接的动态规划而言，并没有对路劲进行记忆，所以，如何对于一个数组进行置零是很大的问题，对于我的思维来说，我会考虑在加上一个大小合适的记忆数组，对于每一次的路径进行记忆，但是，我认为这十分地耗费空间，而且代码也并不优雅。

通过题解的思考，这道题的解法是一个四维的动态规划，由于平时遇到的数据二维居多，对于思维的数组，一时间难以理解。最主要的在于，第一遍与第二遍是否应该分开思考的问题。

通过前面对于二维动态规划的思考，如果是按照模拟的方法，对于每次数组的遍历都采用分离的思想，则每次都是贪心算法，最终获得的是局部最优解，难以证明就是整体最优解。所以在思考四维的动态规划时，也不能将两次遍历分开思考。

对于相关的四维动态规划数组，其存储的应该就是，一次和第二次走到相关x，y位置是取到的最大值。两次走法应该是在相同时空观下的。但是，由于第一次走后会取走数，所以最终，在走到相同位置时，要减去相关位置的数。一定要将动态规划数组在某某位置的值和相应数组在某某位置的值分开思考。

## 1010

[幂次方](https://www.luogu.com.cn/problem/P1010)

通过提示，想到对于一个数进行问题的分解，每次只做一层，用递归的方法。

很容易想到需要用到二进制进行求解。

通过阅读大佬的题解能得到一个很新的思路

```c++
#include<iostream>
#include<cmath>
using namespace std;
int a;
void fff(int x)
{
    for(int i=14;i>=0;i--) //两万的数据最多是2（14）
    {
        if(pow(2,i)<=x){
        //pow（n，m）在cmath库中，返回n^m；枚举出第一个幂次方
            if(i==1) cout<<"2"; //2（1）不用再往后分解了且2^1输出为2，单独出来
            else if(i==0) cout<<"2(0)"; //2（0）也不用再往后分解了，单独出来
            else{ //若i>1则继续分解指数i
                cout<<"2(";
            fff(i);
            cout<<")";
            }
            x-=pow(2,i); //继续循环分解余下的
            if(x!=0) cout<<"+";
            //加号处理的最简单方法：若此x还没分解完，则后面还有项，所以输出一个+号
        }
    }
}
int main()
{
    cin>>a;
    fff(a);
    return 0;
}
 
```

## DFS的算法学习

[LCR 175. 计算二叉树的深度 - 力扣（LeetCode）](https://leetcode.cn/problems/er-cha-shu-de-shen-du-lcof/description/)

非常简单的一道DFS的算法题目，计算二叉树的深度， 其实计算什么的深度都是一样的。这道题目相当于已经将应用的场景抽象化了，所以难度不高，在正式的应用中，真正的难度在于如何能够想到这个算法。

DFS算法的根本是枚举，将所有可能的情况都按照一定的顺序进行了枚举。关键在于回溯的机制。当一条路走到底后，就进行回溯，将之前还存在有路没走的节点再次进行。

话不多说上源码

```c++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left),
 * right(right) {}
 * };
 */
class Solution {
public:
    int calculateDepth(TreeNode* root) {
        if (root == nullptr)
            return 0;
        int ldepth = 1;
        int rdepth = 1;
        ldepth += calculateDepth(root->left);
        rdepth += calculateDepth(root->right);
        return ldepth > rdepth ? ldepth : rdepth;
    }
};
```

[226. 翻转二叉树 - 力扣（LeetCode）](https://leetcode.cn/problems/invert-binary-tree/description/)

简单的DFS算法可以进行实现，先找到最小的树，然后将其反转，最后在将其根节点进行反转。但是唯一的问题在于，原来又有一个疑问是有可能左右指树可能有空，但是想想，其实有空也应该进行反转，所以在写的时候疑惑解消了

```c++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if(root == nullptr)
            return root;
        invertTree(root->left);
        invertTree(root->right);
        TreeNode* temp;
        temp = root->left;
        root->left = root->right;
        root->right = temp;
        return root;
    }
};
```

[八皇后](https://www.luogu.com.cn/problem/P1219)

同样需要用到DFS算法，但是这题对我来说的难点在于，如何寻找状态和判断对角线已经被占用

通过题解，可得将每次下完一个棋，棋盘剩余的资源为一个状态，向下进行传递。同时，对于对角线来说，存在一定的规律，从右到左的行下标与列下标的和在同一对角线相等且唯一，从左到右，行下标与列下标的差在同一对角线值相等且唯一。

```c++
#include<iostream>
class Solution{
    private:
        int size;  //表格的大小
        int rows[14],colunms[14],r_l[27],l_r[27];
        int solutions;
    public:
        int GetSoutions() {
            return solutions;
        }   //用于输出解的个数

        void Solve(){
            int n;
            std::cin>>n;
            this->size = n;
            queen(1);
            printf("%d",this->GetSoutions());
        }

    private:
        void myprint(){
            if(solutions<3){
                for(int i = 1 ;i<=size ; i++)
                    std::printf("%d ",rows[i]);
                putchar('\n');
            }
            this->solutions++;
        }


    // 查询合适的位置放置一枚queen，如果没有判断输出，有则标记状态，在进行下次状态转移
        void queen(int row){
            //row大于行数size，说明到达边界，要么是全部放置完成
            if(row>size){
                myprint();
                return;
            }
            else{
                //保证字典序从1开始
                for(int col = 1 ;col<=size;col++){
                    //说明相关列没有被占领，对角线也没有
                    //在此处我曾将row与col差的值进行互换,输出的结果就是错误的,目前还没具体明白是为什么
                    if((!colunms[col]) && (!r_l[col+row]) && (!l_r[row-col+size])){
                        rows[row] = col;    //直接记录相关的列，方便下次进行输出
                        colunms[col] = 1;
                        r_l[col+row] = 1;
                        l_r[row-col+size] = 1;
                        queen(row+1);   //状态转移，按照字典序，需从行号递增
                        
                        //从上个函数跳出，说明已经完成了当前的这个状态的记录的所有结果需要重新进行上个状态的记录，
                        //故清除当前状态的记录
                        colunms[col] = r_l[col+row] = l_r[row-col+size] = 0;
                    }
                }
            }
        }      
};

int main(){
    Solution ans = Solution();
    ans.Solve();
    return 0;
}
```

[P5194](https://www.luogu.com.cn/problem/P5194)

通过阅读题目，容易直接写出深度优先的算法，同时还可以想到类似背包一类。但是，分析数据的大小为1000，至少要做1000^2次运算, 除了AC的答案,其他全部超时了. 

所以设计到深度优先搜索的算法优化, 就是剪枝的理论.

目前来说, 对于剪枝的理解就是, 通过对题目数据进行分析, 方向对于一些搜索的路径不需要再次搜索. 如题中, 但当前的砝码超出了承受范围C, 则之后的砝码都会超出, 可以直接返回, 这点只需要在判断时加上return语句即可, 但同时, 当前砝码必定大于等于前面两个砝码的质量之和, 但加上当前的砝码超出时, 直接返回后, 由于上一个状态并不能知道当前状态的下一个状态已经超出, 还会再次跳过下一个状态, 直接进行下下个, 这个对于当前的数据集来说就没有必要了, 下一个砝码超出, 则下下个砝码必定超出.

同时存在关系

```c++
weight[i]+weight[i+3]<C;
weight[i]+weight[i+1]+weight[i+2]<C;
//所以在i状态下,可以直接跳到i+3的状态,避免了对i+1,i+2的计算,所以,也许直接从大到小搜索才是正解?
```

```c++
#include<iostream>
#include<algorithm>
using namespace std;
long long sum[1005],a[1005],ans,n,c;
void dfs(int cur,long long x){  //cur是为了标记当前的位置，x是记录当前的大小，防止超过C
    if(x>c) return; //此时累加和已经超过了承受的范围
    if(sum[cur-1]+x<=c){    //对于当前位置来说，如果前面的砝码全部取上加上现在的质量没有超过C，减少了前几次的累加操作
        ans = max(ans,sum[cur-1]+x);
        return;
    }
    ans = max(ans,x);   //当前状态已经是累加完一个数的状态了，前缀和判断的是该数之前的所有大小，进行细分
    for(int i=1;i<cur;i++)
        dfs(i,x+a[i]);      //从第一次最大的做不了后，他直接就从最小的开始一个个递归了，从这里开始是常态化的搜索，剪枝操作在上一步的前缀和里
}
int main()
{
    cin>>n>>c;
    for(int i=1;i<=n;i++){
        cin>>a[i];
        sum[i]=sum[i-1]+a[i];   //前缀和数组
    }
    dfs(n+1,0);
    cout<<ans<<endl;
    return 0;
}
```

[P1162 填色问题](https://www.luogu.com.cn/problem/P1162)

做这道题的目的是为了能够锻炼BFS算法的思维，但是在题解中出现了比较优秀的DFS算法值得学习其中的思想

```c++
#include <iostream>
using namespace std;
int a[32][32], b[32][32];
int dx[5] = {0, -1, 1, 0, 0};
int dy[5] = {0, 0, 0, -1, 1};
int n, i, j;

void dfs(int p, int q)
{
    int i;
    if (p < 0 || p > n + 1 || q < 0 || q > n + 1 || a[p][q] != 0)
        return; // 说明已经超过了搜索的范围
    a[p][q] = 1;
    for (i = 1; i <= 4; i++)
        dfs(p + dx[i], q + dy[i]); // 先该点的四周进行搜索
}

int main()
{
    cin >> n;
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++)
        {
            cin >> b[i][j];
            if (b[i][j] == 0)
                a[i][j] = 0;
            else
                a[i][j] = 2; // 目前这里为什么直接赋值为2还不清楚
        }

    dfs(0, 0); // 这的dfs的作用是通过染色法，将有被围墙保护起来的水进行染色

    for (i = 1; i <= n; i++)
    {
        for (j = 1; j <= n; j++)
        {
            if (a[i][j] == 0)
                cout << 2 << ' '; // 说明这里的水是之前被围墙保护起来的没有染色
            else
                cout << b[i][j] << ' ';
        }                           // a数组中保存的是将原来包括所有墙一起染色的答案。
            cout << '\n';
    }
    return 0;
}
```

题解的发布者的整体思想是类似在画图选择颜色中的方向选择。

​	在一开始的思考中，我都是通过正向的思维，在想，如何判断到达围墙边缘，同时判断处于围墙的内部。
​	从现在看来，如果我使用正向思维的DFS算算法，就需要首先找到属于围墙中心的一点，然后从这个点开始做扩散。但是如何判断这个点是围墙内的点是一个非常困难的问题，虽然从题目中已经确定，闭合圈中一定可以到达。其实可从触碰到的任意一个点进行判断，但是总感觉有点不够优雅。

​	大佬的解法是直接从外围开始，将颜料倒进水里，通过dfs的扩散效果，将除了被围墙保护起来的水进行染色，包括围墙，然后再通过和原来的状态进行对比，得到那些水是被围墙保护起来的，总体效果类似于反选。

## BFS的学习

对于BFS来说, 就相当于是对一棵树进行层序遍历, 然后再得出结果, 需要将每一个节点对应的下一个节点进行记录. 可以想到是先进先出的思想.

[P1162 填色问题](https://www.luogu.com.cn/problem/P1162)

同样也是这个问题, 但是采用的是BFS的想法

题解的提供者同样也是使用的反选的方法进行搜索的. 可见思路的重要性.

```c++
#include<iostream>
#include<cstdio>
#include<queue>
using namespace std;
const int M = 31;   //从1开始记录图像位置
int map[M][M];
bool vis[M][M];     //用于记录是否是边界块，其实反向就是说这些不是被保护的块
int n,m,a,b,c;
queue<int> q;


void bfs(int x, int y){
    vis[x][y] = 1;
    q.push(x);
    q.push(y);
    while(!q.empty()){
        int  w = q.front();
        q.pop();
        int e = q.front();
        q.pop();

        //然后向该点的四周进行判断
        //只有周围是未被包围的，同时不超出范围，同时没有被判断过，就将这个点存入。稍后再进行判断
        if(map[w+1][e]== 0 && w!=n && !vis[w+1][e]) vis[w+1][e] = 1 , q.push(w+1), q.push(e); 
        //原题解说可以用结构体。确实很多地方用结构体的话，代码的可读性会更高。
        if(map[w-1][e] == 0 && w != 1 && !vis[w-1][e] )    vis[w-1][e] = 1,q.push(w-1),q.push(e);
        if(map[w][e+1] == 0 && e != n && !vis[w][e+1] )    vis[w][e+1] = 1,q.push(w),q.push(e+1);
        if(map[w][e-1] == 0 && e != 1 && !vis[w][e-1] )    vis[w][e-1] = 1,q.push(w),q.push(e-1);

    }
}
int main(){
    cin>>n;
    for(int i = 1;i<=n;i++){
        for(int j =1 ;j<=n;j++){
            cin>>map[i][j];
            if(map[i][j] == 1) vis[i][j] = 1;
        }
    }

    for(int i = 1;i<=n;i+=n-1){ //直接就判断两个对角上的点
        for(int j = 1;j <= n; j++){
            if(vis[i][j]) continue;     //说明触发到了边界点从这个点
            bfs(i,j);
        }
    }

    for(int i = 1 ; i <= n ; i = i + n - 1 )        //
    {
        for(int j = 1 ; j <= n ; j++)
        {
            if(vis[j][i])    continue;
            bfs(j,i);            //十分重要！！！把它换过来，枚举另一组边界;可能会存在中间被拦腰隔断的情况，BFS无法自动移动到其他点
                                //但可以采用上一个题解给的方法将，再整体的外围再进行一圈包裹，就可以保证必定能够自由移动。
        }
    }

     for(int i = 1 ; i <= n ; i++)                //
    {
        for(int j = 1 ; j <= n ; j++ )
        {
            if(!vis[i][j])    cout<<"2"<<" ";        //如果未被标记，这一定是闭合‘1’中的‘0’， 输出‘2’； 
            else     cout<<map[i][j]<<" ";;
        }
        cout<<endl;
    } 
    return 0;
}
```

实现的方法还是比较符合典型的BFS的实现方法的

这里放一下我根据上一个题解进行的优化尝试
根据将外围包裹一圈, 这样就可以直接是判断点进行自由移动, 可以减少一点代码量, 但是多了一点计算.

```c++
#include<iostream>
#include<cstdio>
#include<queue>
using namespace std;
const int M = 32;   //从1开始记录图像位置
int map[M][M];
bool vis[M][M];     //用于记录是否是边界块，其实反向就是说这些不是被保护的块
int n,m,a,b,c;
queue<int> q;


void bfs(int x, int y){
    vis[x][y] = 1;
    q.push(x);
    q.push(y);
    while(!q.empty()){
        int  w = q.front();
        q.pop();
        int e = q.front();
        q.pop();

        //然后向该点的四周进行判断
        //只有周围是未被包围的，同时不超出范围，同时没有被判断过，就将这个点存入。稍后再进行判断
        if(map[w+1][e]== 0 && w!=n+1 && !vis[w+1][e]) vis[w+1][e] = 1 , q.push(w+1), q.push(e); 
        //原题解说可以用结构体。确实很多地方用结构体的话，代码的可读性会更高。
        if(map[w-1][e] == 0 && w != 0 && !vis[w-1][e] )    vis[w-1][e] = 1,q.push(w-1),q.push(e);
        if(map[w][e+1] == 0 && e != n+1 && !vis[w][e+1] )    vis[w][e+1] = 1,q.push(w),q.push(e+1);
        if(map[w][e-1] == 0 && e != 0 && !vis[w][e-1] )    vis[w][e-1] = 1,q.push(w),q.push(e-1);

    }
}
int main(){
    cin>>n;
    for(int i = 1;i<=n;i++){
        for(int j =1 ;j<=n;j++){
            cin>>map[i][j];
            if(map[i][j] == 1) vis[i][j] = 1;
        }
    }

    for(int i = 0;i<=n;i+=n){ //直接就判断两个对角上的点
        for(int j = 1;j <= n; j++){
            if(vis[i][j]) continue;     //说明触发到了边界点从这个点
            bfs(i,j);
        }
    }

    // for(int i = 1 ; i <= n ; i = i + n - 1 )        //
    // {
    //     for(int j = 1 ; j <= n ; j++)
    //     {
    //         if(vis[j][i])    continue;
    //         bfs(j,i);            //十分重要！！！把它换过来，枚举另一组边界;可能会存在中间被拦腰隔断的情况，BFS无法自动移动到其他点
    //                             //但可以采用上一个题解给的方法将，再整体的外围再进行一圈包裹，就可以保证必定能够自由移动。
    //     }
    // }

     for(int i = 1 ; i <= n ; i++)                //
    {
        for(int j = 1 ; j <= n ; j++ )
        {
            if(!vis[i][j])    cout<<"2"<<" ";        //如果未被标记，这一定是闭合‘1’中的‘0’， 输出‘2’； 
            else     cout<<map[i][j]<<" ";;
        }
        cout<<endl;
    } 
    return 0;
}
```

[P1443](https://www.luogu.com.cn/problem/P1443)

第一道自己写的题目, 但是写着写着从BFS写成了DFS, 虽然当然直接进行DFS显然超时了, 需要进行剪枝.先贴一下没有剪枝过的代码, 作为对比

```c++
#include<iostream>
#include<queue>
int a[401][401],b[401][401],n,m,x,y;
int dx[]={2,1,-2,-1,2,1,-2,-1};
int dy[]={1,2,1,2,-1,-2,-1,-2};
bool c[401][401];
// queue<int> q;
using namespace std;

void DFS(int x,int y){
    for(int i = 0 ;i<8;i++){
        if(x+dx[i] < 1 || y+dy[i]< 1  || x+dx[i] > n || y+dy[i]>m || c[x][y]) continue;
        else{
            if(b[x+dx[i]][y+dy[i]] !=-1)
                b[x+dx[i]][y+dy[i]] = min(b[x+dx[i]][y+dy[i]],b[x][y]+1);
            else
                b[x+dx[i]][y+dy[i]] = b[x][y]+1;
            c[x][y] = 1;
            DFS(x+dx[i],y+dy[i]);
            c[x][y] = 0;
        }
    }
    return;
}
int main(){
    cin>>n>>m;
    cin>>x>>y;
    for(int i = 1 ;i<=n;i++){
        for(int j = 1;j<=m;j++){
            b[i][j] = -1;
        }
    }
    b[x][y] = 0;
    DFS(x,y);
    for(int i = 1 ;i<=n;i++){
        for(int j = 1;j<=m;j++){
            cout<<b[i][j]<<' ';
        }
        cout<<endl;
    }
    return 0;
}
```

想来想去没想到有什么剪枝的方法，因为本身就要判断从这个点进行会不会比另一个点进行更快，就相当于时每个点都进行判断了，要对每一条支路进行分析，剪不掉，意味着层数越深，搜索的次数就越多，因为会有很多的支路。所谓的剪枝，也许就是从层数的角度出发，但是这样就是BFS了，所以最终还是使用BFS进行求解。~~对于搜索来说，如何选择合适的搜索方式确实时需要慎重考虑的，回旋镖咋回来了~~

```c++
#include<iostream>
#include<queue>
int a[401][401],b[401][401],n,m,x,y;
int dx[]={2,1,-2,-1,2,1,-2,-1};
int dy[]={1,2,1,2,-1,-2,-1,-2};
bool c[401][401];	//像水扩散一样, 从一个点开始出发,将他的每层的连接进行判断,重叠部分就不用判断了,所以不用取消状态.

using namespace std;
queue<int> q;
void BFS(int x,int y){
    for(int i = 0 ;i<8;i++){
        if(x+dx[i] < 1 || y+dy[i]< 1  || x+dx[i] > n || y+dy[i]>m || c[x][y]) continue;
        else{
            if(b[x+dx[i]][y+dy[i]] !=-1)
                b[x+dx[i]][y+dy[i]] = min(b[x+dx[i]][y+dy[i]],b[x][y]+1);
            else
                b[x+dx[i]][y+dy[i]] = b[x][y]+1;

            q.push(x+dx[i]);
            q.push(y+dy[i]);
        }
    }
    c[x][y] = 1;	//之前不小心放在循环的里面了,还是要注意什么时候要对状态使用完成进行标记,放里面就有DFS的味道了
    if(q.empty())
        return;
    int n_x = q.front();
    q.pop();
    int n_y= q.front();
    q.pop();
    BFS(n_x,n_y);
    return;
}
int main(){
    cin>>n>>m;
    cin>>x>>y;
    for(int i = 1 ;i<=n;i++){
        for(int j = 1;j<=m;j++){
            b[i][j] = -1;
        }
    }
    b[x][y] = 0;
    BFS(x,y);
    for(int i = 1 ;i<=n;i++){
        for(int j = 1;j<=m;j++){
            cout<<b[i][j]<<' ';
        }
        cout<<endl;
    }
    return 0;
}
```

## 30、串联所有单词的字串



滑动窗口优化，我尝试的第一道困难题，毕竟不是算法竞赛，没有想象中难么难。当还是有一定挑战的

```python
#我的解法只使用了简单的枚举，其实并不涉及滑动窗口，在重复度高的情况中容易多次统计，造成计算重复
class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        res = []
        m,n,ls = len(words),len(words[0]),len(s)
        for i in range(ls):
            if(i + m*n >ls):
                break
            differ = Counter()
            for j in range(m):
                word = s[i+j*n : i+(j+1)*n]
                differ[word] += 1
            for word in words:
                differ[word] -=1
                if differ[word] == 0:
                    del differ[word]
            if len(differ) == 0:
                res.append(i)
        return res            






#使用滑动窗口，在最外层的循环中，循环的长度为一个单词的长度，如果是单词整体的减少，通过滑动窗口已经能够进行判断
class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        res = []
        m, n, ls = len(words), len(words[0]), len(s)
        for i in range(n):
            if i + m * n > ls:
                break
            differ = Counter()
            for j in range(m):
                word = s[i + j * n: i + (j + 1) * n]
                differ[word] += 1
            for word in words:
                differ[word] -= 1
                if differ[word] == 0:
                    del differ[word]
                    
                    #下一段是使用滑动窗口的优化
                    #步长为n代表窗口的整体滑动
            for start in range(i, ls - m * n + 1, n):
                if start != i:
                    #word为窗口滑动进入的新词
                    word = s[start + (m - 1) * n: start + m * n]
                    differ[word] += 1
                    #可能上一个词组不是,刚好欠这个词
                    if differ[word] == 0:
                        del differ[word]
                    #上一个
                    word = s[start - n: start]
                    differ[word] -= 1
                    if differ[word] == 0:
                        del differ[word]
                if len(differ) == 0:
                    res.append(start)
        return res

```

 ## 135、分发糖果

第二道困难题，关于数组的，确实有难度，在于一点巧劲，常规解法的话其实需要对题目的数学模型有一定的理解

```python
int candy(int* ratings, int ratingsSize) {
    int left[ratingsSize];
    for (int i = 0; i < ratingsSize; i++) {
        if (i > 0 && ratings[i] > ratings[i - 1]) {
            left[i] = left[i - 1] + 1;
        } else {
            left[i] = 1;
        }
    }
    int right = 0, ret = 0;
    for (int i = ratingsSize - 1; i >= 0; i--) {
        if (i < ratingsSize - 1 && ratings[i] > ratings[i + 1]) {
            right++;
        } else {
            right = 1;
        }
        ret += fmax(left[i], right);
    }
    return ret;
}

作者：力扣官方题解
链接：https://leetcode.cn/problems/candy/solutions/533150/fen-fa-tang-guo-by-leetcode-solution-f01p/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。


class Solution:
    def candy(self, ratings: List[int]) -> int:
        n = len(ratings)
        ret = 1
        inc, dec, pre = 1, 0, 1

        for i in range(1, n):
            if ratings[i] >= ratings[i - 1]:
                dec = 0
                pre = (1 if ratings[i] == ratings[i - 1] else pre + 1)
                ret += pre
                inc = pre
            else:
                dec += 1
                if dec == inc:
                    dec += 1
                ret += dec
                pre = 1
        
        return ret

作者：力扣官方题解
链接：https://leetcode.cn/problems/candy/solutions/533150/fen-fa-tang-guo-by-leetcode-solution-f01p/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```

## 42、接雨水

第三道困难题，本来还想通过自己通过的，但是还是被最极端的用例给爆内存了

```python

#自己的解法， 通过每一层进行扫描，但是前提是根据给出的数据创建一个相关的矩阵判断边界，有点像是模拟的做法
class Solution:
    def trap(self, height: List[int]) -> int:
        
        #创建一个矩阵记录边界
        n = len(height)
        max_height = max(height)
        bow = [[0 for _ in range(n)] for _ in range(max_height)]
        for i in range(n):
            for j in range(height[i]):
                bow[j][i] = 1
        
        #只有判断到一行中两个一之间的区域的时候，直接将其充满，毕竟没说石柱会有空隙
        rain = 0
        start=end=0
        for i in range(max_height):
            start=end=0
            for j in range(n):
                if bow[i][j] == 1 :
                     rain += end - start
                     start = end = j
                else:
                    if bow[i][start] ==1:
                        end += 1
        return rain
    
    
#总体来说，在构建矩阵的时候，内存消耗过大，被极端用例给爆了
```

## 202.快乐数

本身题目并不难, 思路也比较好像, 但是双指针的思路我一时间还是没有想到的, 同时关于他的时间优化我觉得还是有必要记录一下的

```python
#第一遍的双指针
class Solution:
    def doit(self,n: int):
        nums=[]
        res = 0
        while(n!=0):
            nums.append(n%10)
            n //= 10
        for i in range(len(nums)):
            res += nums[i]**2
        return res
    def isHappy(self, n: int) -> bool:
        fast = n
        for i in range(2):
            if fast == 1:
                return True
            fast = self.doit(fast)
        slow = n
        while(fast != slow):
            slow = self.doit(slow)
            for i in range(2):
                fast = self.doit(fast)
                if fast == 1:
                    return True
        return False
# 将每次快指针指向的数组
```

## 6、z字型变换

还是比较简单的，就是纯粹的模拟，但是有一个需要注意的地方，会使题目更简单. 虽然在字体形式上在上升行中会出现很多的空, 但是对于题目要求的输出来说并没有需要按照z字的形式输出, 所以直接忽略空白即可, 所以只需要考虑每个字符应该处在哪一行,同时按照顺序执行就行.

```python
class Solution:
    def convert(self, s: str, numRows: int) -> str:
        if numRows < 2 : return s #小于两行的化和直接输出没有区别
        res = ["" for _ in range(numRows)]
        i, flag = 0,-1
        for c in s :
            res[i]+= c
            if i == 0 or i == numRows-1:
                flag = -flag
            i+=flag
        return "".join(res)            
                
```

## [1715、分割回文字符IV](https://leetcode.cn/problems/palindrome-partitioning-iv/description/)

困难题，确实有点出乎意料. 对于一般的字符来说, 还没用到过动态规划. 要考虑到对于一个字符串来说, 如何分割确保分割出来的子字符串为回文,并没有确定的公式, 所以就说明必须要进行一些枚举运算. 但是, 在枚举的过程中, 会存在很多重复的判断是否为回文的字符串, 对于一个变长的子串, 其子串如果在前面已经判断过是否为回文, 那么在对其重复计算明显浪费了算力.

官方题解使用了一个动态规划数组, 在于任何子串, 其掐去两端的子串如果为回文, 那么, 掐去的两端字符如果相等, 那么其就为回文. 这样每次回文判断其实只需要两次计算.

```java
class Solution {
    public boolean checkPartitioning(String s) {
        int n = s.length();
        boolean[][] isPalindrome = new boolean[n][n];

        //确定每次判断字符的长度，由于只是对判断原字符中的子字符是否是回文，所以只需要从小到大
        //又因为设计上的动态规划
        //本部分先将所有的子串是否为回文进行记录，虽然其中也有许多的冗余计算， 但是还是相对来说较少
        for (int length = 1; length < n; length++) {
            for (int start = 0; start <= n -length; start++){
                //end是可以取到的
                int end = start + length-1;
                if (length == 1) {
                    isPalindrome[start][end] = true;
                }
                else if(length == 2) {
                    isPalindrome[start][end] = (s.charAt(start) == s.charAt(end));
                }
                else{
                    //因为length从小到大，所以判断必定是从3->2,由4->3, 而其长度为这些的子串都会在前面的计算中判断过
                    isPalindrome[start][end] = ((s.charAt(start)==s.charAt(end)) && isPalindrome[start+1][end-1]);
                }
            }
        }

        //直接确定中间字符串的位置即可
        //1、0->start-1,2、start->end, 3、end+1->length
        for(int start = 1;start<n-1;start ++){
            if(!isPalindrome[0][start-1]) {
                continue;
            }
            for(int end=start; end <n-1;end++){
                if(isPalindrome[start][end] && isPalindrome[end+1][n-1]){
                    return true;
                }

            }
        }
        return false;
    }
}
```

## [汇总区间](https://leetcode.cn/problems/summary-ranges/description/?envType=study-plan-v2&envId=top-interview-150)

也不知道怎么之前就没有写出来, 非常普通的一个模拟. 但是他的判断逻辑写的有点有趣

```go
func summaryRanges(nums []int) []string {
    var ans []string
    for i, n := 0, len(nums); i<n; {
        left := i
        
        //类似一个if判断语句， 但是这个写法很抽象
        for i++; i<n && nums[i-1] + 1 == nums[i];i++ {
        }
        s := strconv.Itoa(nums[left])
        if left < i-1 {
            s += "->" + strconv.Itoa(nums[i-1])
        }
        ans = append(ans, s)
    }
    return ans
}
```

## 3306.元音辅音字母计数 II

当读完题目就想到了滑动窗口发,  不知道算不算种进步, 虽然我脑海中的滑动窗口并没有实现. 感觉还是欠点, 或者说感觉我的逻辑太麻烦不够简洁. 

```go
func countOfSubstrings(word string, k int) int64 {
    word_len = len(word)
    var ans int64
    for win_len := k+5; win_len <= word_len ;win_len++ {
        occur := map[byte]int{'a':0,'e':0, 'i':0, 'o':0,'u':0}
        other := 0
        for i := 0 ;i <=win_len; i++ {
            _, ok := map[word[i]]
            if ok {
                map[word[i]]++;
            }else{
                other++;
            }
        }
    }
}
//....不行了, 太麻烦了, 确实不是一个好的答案, 不是很好模拟, 判断太多了.到后面就容易造成...
```

题解给出的答案是, 通过将统计恰好改为至少. 感觉也是一种题型.

如果将题目先改成`至少出现辅音k次`, 那么判断逻辑就会减少, 只要确保形成的子字符串中, 至少保存了k个即以上就行. 而恰好则可以转化成count(k) - count(k+1)

```go
func countOfSubstrings(word string, k int) int64 {
	vowels := map[byte]bool{'a': true, 'e': true, 'i': true, 'o': true, 'u': true} //用于快速判断是否为元音
	count := func(m int) int64 {
		n := len(word)
		var res int64 = 0
		consonants := 0
		occur := make(map[byte]int)
		for i, j := 0, 0; i < n; i++ {
            //找到以当前i开头的子串能满足的最短子串
			for j < n && (consonants < m || len(occur) < 5) {
				if vowels[word[j]] {
					occur[word[j]]++
				} else {
					consonants++
				}
				j++
			}
			if consonants >= m && len(occur) == 5 {
                //对于当前子串来说已经满足了条件, 那么,后面继续添加长度就必定满足条件, 不用判断
				res += int64(n - j + 1)
			}
            //接下来当前子串开头i要向后移位, 需要判断是否会对当前的满足条件造成影响
			if vowels[word[i]] {
				occur[word[i]]--
				if occur[word[i]] == 0 {
					delete(occur, word[i])
				}
			} else {
				consonants--
			}
		}
		return res
	}
	return count(k) - count(k+1)
}
```

## [1920.基于排列构建数组](https://leetcode.cn/problems/build-array-from-permutation/description/?envType=daily-question&envId=2025-05-06)

从题目来说, 不考虑优化就是一件非常简单的任务.解法二的思路比较有意思. 这对数据来说, 所有的数据都不会超过1000的大小. 对于如何原地交换的问题在于, 直接交换, 可能只有一个数据满足要求, 会导致另一个数据失效, 同时也会打乱原来排序号的数据. 关键在于如何能够在一个地方同时存储两个数据, 一个代表的是原数据, 另一个代表的是更改后的数据. 
通过观察数据最大到999, 所以可以将更改数据整体存储在1000位以上, 在通过第二遍历就能够将原数据去除, 只保留1000位以上的数据

```go
func buildArray(nums []int) []int {
    for i,_ :=  range nums {
        nums[i] += 1000*(nums[nums[i]]%1000);
    }
    for i,_ := range nums{
        nums[i] /= 1000
    }
    return nums
}
```

```java
class Solution {
    public int[] buildArray(int[] nums) {
        int n = nums.length;
        for(int i = 0;i<n;i++){
            nums[i] += 1000*(nums[nums[i]]%1000);
        }
        for(int i = 0;i<n;i++){
            nums[i] /= 1000;
        }
        return nums;
    }
}
```

但是会降低运行速度, 毕竟变成O(n^2)
