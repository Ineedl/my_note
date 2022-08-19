## 时间复杂度

O(n^3) 


## 作用

弗洛伊德算法用于找出图中每一个点，到另一个点的最短路径(注意并不是距离，而是这条路径上经过的点)，之后可以根据返回的最短路径结果来回溯出最短路径长度。

## 实现

弗洛伊德算法使用了动态规划的思想，其将所有节点node[i]都当作该图中已有路径中的某一个中间点(那些起点或是终点为node[i]的路径不算)，并且计算

起点到中间点+中间点到终点

的距离，如果该距离小于原来的路径长度，就把原来的路径长度更新为该长度。

如此循环的动态规划下去。


## 代码实现

> 图的图形参考

![](https://note.youdao.com/yws/api/personal/file/9792552B2FBE41539EEA8DED4A554221?method=download&shareKey=d7c2427d03318fe462c693c6f451cc74)

```
//C代码实现

    
#include<stdio.h>
#include<stdlib.h>

void Floyd(const int nNumSize,int picture[][nNumSize],int path[][nNumSize]);

//路径溯源
void printPath(int start,int end,int nSize,int path[][nSize]);


int main()
{
    //此处999表示两点不相连，此处为无向图。 
    int a[9][9]={
        {0,4,9999,9999,9999,9999,9999,8,9999},
        {4,0,8,9999,9999,9999,9999,11,9999},
        {9999,8,0,7,9999,4,9999,9999,2},
        {9999,9999,7,0,9,14,9999,9999,9999},
        {9999,9999,9999,9,0,10,9999,9999,9999},
        {9999,9999,4,14,10,0,2,9999,9999},
        {9999,9999,9999,9999,9999,2,0,1,6},
        {8,11,9999,9999,9999,9999,1,0,7},
        {9999,9999,2,9999,9999,9999,6,7,0}
        };
    int b[9][9];
    Floyd(9,a,b);
    for(int i=0;i<9;++i)
    {
        printf("%d : ",i);
        for(int j=0;j<9;j++)
        {
            printf("%d ",b[i][j]);
        }
        printf("\n");
    }
    printPath(0,8,9,b);
}

void Floyd(const int nNumSize,int picture[][nNumSize],int path[][nNumSize])
{
    //pathValue用来存放两点之间变化的最短路径，算法结束后它也存放的为两点之间的最短路径，可以动态分配内存然后一起返回
    int pathValue [nNumSize][nNumSize];
    for(int i=0;i<nNumSize;++i)
    {
        for(int j=0;j<nNumSize;++j)
        {
            pathValue[i][j]=picture[i][j];
            path[i][j]=-1;
        }
    }
    for(int i=0;i<nNumSize;++i)
    {
        for(int j=0;j<nNumSize;++j)
        {
            for(int k=0;k<nNumSize;++k)
            {
                if(pathValue[i][k]+pathValue[k][j] < pathValue[i][j])
                {
                    pathValue[i][j]=pathValue[i][k]+pathValue[k][j];
                    path[i][j]=k;
                }
            }
        }
    }
}

//路径溯源
void printPath(int start,int end,int nSize,int path[][nSize])
{
    if(-1==path[start][end])
    {
        printf("%d -> %d \n",start,end);
    }
    else
    {
        int mid = path[start][end];
        printPath(start,mid,nSize,path);
        printPath(mid,end,nSize,path);
    }
}

```