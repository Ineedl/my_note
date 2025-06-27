[toc]

## OptionsAPI和CompositionAPI

配置式API导致数据混合在了一起，组合式API解决了这个问题

* 两种API底层逻辑一致
* 配置式API是基于组合式API实现的
* 官方更推荐组合式API

### 配置式API例子

```vue
<template>
	<div>
		姓名: <input v-model="userName"/> {{userName}} <br />		<!-- 使用v-model绑定变量 -->
      																										 <!-- {{}} 用于在html中访问vue变量-->
      薪水: <input type="number" v-model="salary"/> {{salary}} <br />	
		<button v-on:click="addSalary">提交</button>		<!-- 绑定方法 -->
	</div>
</template>


<script lang="ts">
	export default{
		data(){
			return{
				userName:'roy',
        salary:15000
			}
		},
    methods:{
      addSalary(){
        this.salary += 1000
      }
    }
	}
</script>

<style scoped>

</style>
```

### 组合式AP例子

```vue
<template>
	<div>
		姓名: <input v-model="userName"/> {{userName}} <br />		<!-- 使用v-model绑定变量 -->
      																										 <!-- {{}} 用于在html中访问vue变量-->
      薪水: <input type="number" v-model="salary"/> {{salary}} <br />	
		<button v-on:click="addSalary">提交</button>		<!-- 绑定方法 -->
	</div>
</template>


<script lang="ts">
import { ref } from 'vue';
	export default{
		setup(){
			let userName=ref('roy')
			let salary=15000
			function addSalary(){
				salary.value+=1000
			}
			return {userName,salary,addSalary}	//抛出要用的变量和方法
		}
	}
</script>

<style scoped>

</style>
```

#### vue3写法

```vue
<template>
	<div>
		姓名: <input v-model="userName"/> {{userName}} <br />		<!-- 使用v-model绑定变量 -->
      																										 <!-- {{}} 用于在html中访问vue变量-->
      薪水: <input type="number" v-model="salary"/> {{salary}} <br />	
		<button v-on:click="addSalary">提交</button>		<!-- 绑定方法 -->
	</div>
</template>

<!-- vue3写法 -->
<script setup lang="ts">
import { ref } from 'vue';
let userName=ref('roy')
let salary=15000
function addSalary(){
  salary.value+=1000
}
</script>

<style scoped>

</style>
```

