## 作用

kmp算法不同于暴力匹配算法，当其匹配失败时，会最大程度的将模式串在主串对比中往后移动，而不是像暴力匹配算法那样一次只移动一个位置。


## 实现

kmp算法的核心是next数组，next数组为模式串的一个属性，其表示模式串在该位置前面字符串的最长相同的真前缀和真后缀长度。

当该处位置匹配失败时，模式串可以将对比位置移动到后缀，而不是移动到前缀来重新比较，这样就移动了相当长的距离。

## 代码实现

```
//c++的kmp实现

class Solution {

public:
    int strStr(string haystack, string needle) {
        int nSize1 = haystack.size();

        vector<int> next = getNext(needle);
        int j=0;
        for(int i=0;i<nSize1;++i)
        {
            while(j != 0 && haystack[i]!=needle[j])
            {
                j=next[j];
            }
            if(haystack[i]==needle[j])
            {
                ++j;
            }
            if(j==needle.size())
            {
                return i-needle.size()+1;
            }
        }
        return -1;
    }
    vector<int> getNext(string str)
    {
        int nSize=str.size();
        vector<int> next(nSize,0);
        int j=0;
        for(int i=2;i<nSize;++i)
        {
            while(j!=0&&str[i-1]!=str[j])
            {
                j=next[j];
            }
            if(str[i-1]==str[j])
            {
                j++;
            }
            next[i]=j;
        }
        return next;
    }
};

```