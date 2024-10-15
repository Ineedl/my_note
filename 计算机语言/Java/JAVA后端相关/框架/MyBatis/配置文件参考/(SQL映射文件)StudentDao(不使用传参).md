```

<?xml version="1.0" encoding="UTF-8" ?>

<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--指定约束文件，mapper标签使用的检查-->

    <!--
    mapper为文件的根标签,由于有约束文件,该标签必须存在
    namespace为命名空间,是唯一值,可以是自定义字符,但是要求为接口的全限定名称,这在使用动态代理时很有用
    一个namespace标识一个映射文件

    -->
<mapper namespace="indi.cjh.dao.StudentDao">
    <!--
        mapper中可以指定对应的操作标签
        <select>表示查询相关语句
        <update>表示数据更新相关语句
        <insert>
        <delete>
        <create>等都类似

    -->
    <select id="selectStudents" resultType="indi.cjh.mapper.Student">
        <!--
            id唯一标识一个sql语句,可以自定义,但是要求使用接口中的方法名称.这个跟后面使用代理来进行增删改查有关系
            resultType标识结果类型,即sql语句结果执行后每行数据对象所对应的class类型,需要为全类名
            标签内部写sql语句.
        -->
        select id,name,email,age from student order by id
    </select>


    <insert id="insertStudent">
        <!--此处默认使用了实体类的传参-->
        insert into student values(#{id},#{name},#{email},#{age})
    </insert>


</mapper>

<!--SQL映射文件-->


```