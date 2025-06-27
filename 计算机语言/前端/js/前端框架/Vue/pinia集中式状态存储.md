## 介绍

这是一个vue3中推荐使用的库。

* 注意pinia不默认持久化，他在内存中，刷新就消失

## 状态的理解

在任意Vue界面之间共享的存储数据。

* 例如登录信息

* vue2中使用的是vuex，vue3中使用的是pinia

## 使用

### 简单创建

```ts
import {createPinia} form 'pinia'
const pinia = createPinia()
app.use(pinia)
```

### 创建store

一个store可以理解为mysql中的一个库，保存一部分数据。Pinia的store中有三个概念

* state：数据
* getter：服务，用来获取返回数据
* action：控制器，用于组织业务逻辑

`创建store`

```ts
import {defineStore} from "pinia";


export const userStore = defineStore("userStore",{
    actions:{
        changeUsername(value:string){
            if(value && value.length < 10){
                this.username += value
            }
        }
    },
    getters:{
        getUsername():string{
            return this.username.toUpperCase();
        }
    },
    state(){
        return {
            username:'-'
        }
    }
})


<!-- 混合式 写法-->
import {defineStore} from "pinia";


export const userStore = defineStore("userStore",()=>{
  	//相当于是state
		const userInfo = reactive({username:"---"})
		
		//相当于action
    function changeUsername(value:string){
        if(value && value.length < 10){
            userInfo.username += value
        }
    }

		//相当于getters
    function getUsername():string{
        return userInfo.username.toUpperCase();
    }

		//不用区分什么类型 直接返回出去
    return {
        userInfo,
      changeUsername,
      getUsername
    }
})
```

`使用store`

```vue
<script setup lang="ts">
  import { userStore } from './store/user';
  const user = userStore()

  console.log(user.username)		<!-- 使用 -->
  user.username='a'		<!-- 修改 -->
  user.$patch({
    username:'roy2'
  })		<!-- 修改 -->
  user.changeUsername('666')		<!-- 修改 -->
</script>

<template>
  
</template>

<style scoped>

</style>

```

## 转换成引用数据

pinia提供了一个安全的方法 `storeToRefs()` 来转换数据为绑定响应数据

* 如果对pinia中的数据直接使用toRefs()，将会暴露许多不存在的数据

```ts
<script setup lang="ts">
  import { userStore } from './store/user';
  const user = userStore()

  const userInfo = storeToRefs(user)
  console.log(userInfo)
</script>

<template>
</template>

<style scoped>
</style>
```

