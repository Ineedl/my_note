## 时间复杂度

O(n^2)

## 作用

迪斯科算法用于寻找从图中某一点出发时，到达所有点的最短路径长度，而且这些路径都拥有前缀，可以追溯该路径。


## 实现

迪斯科算法使用了贪心算法为基础，按照以下几步来实现。

1. 选择一个起点，从该点出发，并且标记该点，并且以图中所有点设置一个一维数组。

    在该数组中每个点都拥有两个主要属性：起点到达该路径点的最短长度；走起点到该路径点的最短路径，该路径点前面的点。
    
2. 遍历与该点有相关的第一层能达路径点(不包括已标记了的点)，并且在数组中记录从起点到达他们时的长度。

3. 选出2中计算出的路径点中的长度最小路径，并且此时 标记 该路径的终点，此时起点到该点的最短路径长度即为该路径。

4. 从该点继续出发，循环2，3，4步骤，直到所有点被标记。

5. 当所有点被标记后，该一维数组中的数据即为选择起点到所有点的最短路径。


## 代码实现

> 图的图形参考

![](https://note.youdao.com/yws/api/personal/file/9792552B2FBE41539EEA8DED4A554221?method=download&shareKey=d7c2427d03318fe462c693c6f451cc74)

```
//C的矩阵图实现

#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
typedef struct stData{
    int nMinLen;        //起点到该点的最短路径
    int nFrontNode;     //走最短路径时，该节点中的前一个点是谁
    int flag;           //该点是否已经被标记
} stData;

stData* dijkstra(int start,int** a,int nNumSize);

int main()
{
    //此处-1表示两点不相连，此处为无向图
    int a[9][9]={
        {0,4,-1,-1,-1,-1,-1,8,-1},
        {4,0,8,-1,-1,-1,-1,11,-1},
        {-1,8,0,7,-1,4,-1,-1,2},
        {-1,-1,7,0,9,14,-1,-1,-1},
        {-1,-1,-1,9,0,10,-1,-1,-1},
        {-1,-1,4,14,10,0,2,-1,-1},
        {-1,-1,-1,-1,-1,2,0,1,6},
        {8,11,-1,-1,-1,-1,1,0,7},
        {-1,-1,2,-1,-1,-1,6,7,0}
        };

    int** b = (int**)malloc(sizeof(int*)*9);
    for(int i=0;i<9;++i)
    {
        b[i] = (int*)malloc(sizeof(int)*9);
    }
    for(int i=0;i<9;++i)
    {
        for(int j=0;j<9;++j)
        {
            b[i][j]=a[i][j];
        }
    }

    printf("%d\n",b[0][0]);
    stData* data = dijkstra(2,b,9);
    for(int i=0;i<9;++i)
    {
        printf("%d : %d\n",data[i].nMinLen,data[i].nFrontNode);
    }

    return 0;
}

stData* dijkstra(int start,int** a,int nNumSize)
{
    
    int nSize = nNumSize;
    stData* data=(stData*)malloc(sizeof(stData)*nSize);

    for(int i=0;i<nSize;++i)
    {
        data[i].nMinLen=999;
        data[i].flag=0;
    }

    int flag=0;

    data[start].nFrontNode=start;
    data[start].nMinLen=0;

    
    while(flag < nSize)
    {
        int nMin=999;
        int findNode=0;
        
        for(int i=0;i<nSize;i++)
        {
            if(0 == data[i].flag)
            {
                if(nMin>data[i].nMinLen)
                {
                    nMin=data[i].nMinLen;
                    findNode=i;
                }
            }
        }
        
        data[findNode].flag=1;
        
        flag++;
        for(int i=0;i<nSize;++i)
        {
            if(a[findNode][i]!=-1)
            {
                int nowLen = data[findNode].nMinLen + a[findNode][i];
                
                if(data[i].nMinLen > nowLen)
                {
                    data[i].nMinLen=nowLen;
                    data[i].nFrontNode=findNode;
                }
            }
        }
    }

    printf("over %d \n",flag);

    return data;
    
}


```