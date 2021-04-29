<!DOCTYPE html>
<body>
<div id="wc"></div>
<%@ page contentType="text/html; charset=gb2312" %> 
<%@ page language="java" %> 
<%@ page import="com.mysql.jdbc.Driver" %> 
<%@ page import="java.sql.*" %> 
<% 
                        out.print("<center><h1><font color=blue>Matrix Word Cloud English Learning</h1></center>"); 
						//驱动程序名 
						String driverName="com.mysql.jdbc.Driver"; 
						//数据库用户名 
						String userName="root"; 
						//密码 
						String userPasswd="z1012194891"; 
						//数据库名 
						String dbName="DataVisual"; 
						//表名 
						String tableName="map_enword"; 
						//联结字符串 
						String url="jdbc:mysql://localhost/"+dbName+"?user="+userName+"&password="+userPasswd; 
						Class.forName("com.mysql.jdbc.Driver").newInstance(); 
						Connection connection=DriverManager.getConnection(url); 
						Statement statement = connection.createStatement(); 

						for(int i=0;i<26;i++){
							int aa=Integer.valueOf('a')+i;
							char cha = (char) aa;
							//out.print(aa);
							out.print(cha);

							//String sql="SELECT * FROM "+tableName+" where english like 'a%' "+"order by english"; 
							String sql="SELECT * FROM "+tableName+" where english like '"+cha+"%' "+"order by english"; 
							ResultSet rs = statement.executeQuery(sql);  
							// 输出每一个数据值 
							
							String str;
							int j=0;
							while(rs.next()) { 
								str=(rs.getString(2)).substring(0,1);
								out.print(str+" "); 
								j++;
							}
							
							out.print(" "+j+" <br>"); 
							rs.close();
						}
						
						 
						statement.close(); 
						connection.close(); 
%>
<script src="https://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<script>
	var w=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
            var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
            w=w*0.98;
            h=h*0.9;
            var svg=d3.select("body")
            .append("svg")
            .attr("width",w)
            .attr("height",h);
            svg.append("text")
            .attr("font-size","20px")
            .attr("fill","rgb(124,84,57)")
            .attr("font-family","Fantasy")
            .attr("x",w-250)
            .attr("y",50)
            .text("数科 201811153031 曾锐");

</script>
</body>