```

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="indi.cjh.dao.StudentDao">
    <!--
    Student类定义
        public class Student {
        private Integer id;
        private String name;
        private String email;
        private Integer age;
        //各种set与get
    }
    -->

    <!--dao接口定义
    public interface StudentDao {
        public List<Student> selectStudents(@Param("MyName") String name,
                                            @Param("MyAge") Integer age);

        public int insertStudents(Student stu);

        public List<Student> selectStudents2(String name,Integer age,Integer id);

        public List<Student> selectStudents3(Map<String,Object> map);

        public List<Student> selectStudents4();
    }
    -->

    <!--使用resultMap映射属性返回-->
    <resultMap id="myMap" type="indi.cjh.mapper.Student">
        <id column="id" property="age" />
        <result column="name" property="email" />
        <result column="email" property="name" />
        <result column="age" property="id" />
    </resultMap>

    <!--
        resultMap与resultType不要一起使用
        resultMap标签中已制指定了resultType
    -->
    <select id="selectStudents4" resultMap="myMap">
        select id,name,email,age from student
    </select>

    <!--使用Param注解传参-->
    <select id="selectStudents" resultType="indi.cjh.mapper.Student">
        select id,name,email,age from student where name=#{MyName} or age=#{MyAge}
    </select>

    <!--用对象传参-->
    <insert id="insertStudents"> <!-- parameterType="indi.cjh.mapper.Student"(可写可不写) -->
        insert into student(id,name,email,age) values(#{id,javaType=java.lang.Integer,jdbcType=INTEGER},
                                                   #{name},
                                                   #{email,javaType=java.lang.String,jdbcType=VARCHAR},
                                                   #{age})
    </insert>
    <!--按位置传参-->
    <!--
    MyBatis3.4之前使用 #{n}占位
    MyBatis3.4之后使用 #{arg<n>}占位
    -->
    <select id="selectStudents2" resultType="indi.cjh.mapper.Student">
        select id,name,email,age from student where name=#{arg0} or age=#{arg1} and #{arg2} > 0
    </select>

    <!--使用map传参-->
    <!--map代码
        Map<String,Object> data=new HashMap<>();
        data.put("MyName","cjh");
        data.put("MyAge",23);
        data.put("MyId",10);
    -->
    <select id="selectStudents3" resultType="Student">  <!--此处使用了别名-->
        select id,name,email,age from student where name=#{MyName} or age=${MyAge} and #{MyId} > 0
    </select>



</mapper>


```