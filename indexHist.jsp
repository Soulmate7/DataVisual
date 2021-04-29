<!DOCTYPE html>
<title>链接数据库-英文字母可视化byZR</title>
<body>
	<body background="image/moroccan-flower.png"></body>
<div id="wc"></div>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ page language="java" %> 
<%@ page import="com.mysql.jdbc.Driver" %> 
<%@ page import="java.sql.*" %> 
<% 
						//out.print("<center><h1><font color=blue>英语单词首字母统计</h1></center>"); 
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
						int[] count=new int[26];
						for(int i=0;i<26;i++){
							int aa=Integer.valueOf('a')+i;
							char cha = (char) aa;
							String sql="SELECT * FROM "+tableName+" where english like '"+cha+"%' "+"order by english"; 
							ResultSet rs = statement.executeQuery(sql);  
							//String str;
							int j=0;
							while(rs.next()) { 
								//str=(rs.getString(2)).substring(0,1);
								j++;
							}
							count[i]=j;
							//out.print(" "+count[i]+" <br>"); 
							rs.close();
						}
						
						 
						statement.close(); 
						connection.close(); 
%>
<script src="d3.v3.min.js"></script>
		<script>
		    var w=window.innerWidth|| document.documentElement.clientWidth|| document.body.clientWidth;
			var h=window.innerHeight|| document.documentElement.clientHeight|| document.body.clientHeight;
			w=w*0.98;
			h=h*0.95;
			var color=d3.scale.category10();
			var str=new Array(26);
			var cha=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
			var dataset=new Array(26);
			<%for(int i=0;i<26;i++)
			{%>
				dataset[<%=i%>]=<%=count[i]%>;

			<%}%>
			var sum=0;
			for(var i=0;i<26;i++)
			{
				sum=sum+dataset[i];
			}
			var percentage=new Array(26);
			for(var i=0;i<26;i++)
			{
				percentage[i]=dataset[i]/sum;
			}
			console.log(sum);
			console.log(dataset);
			console.log(percentage);
			var linear=d3.scale.linear()
							   .domain([0,d3.max(dataset)])
							   .range([25,h-50]);
			var ww=w/dataset.length;
			var svg=d3.select("body")
			          .append("svg")
					  .attr("width",w)
					  .attr("height",h);
			svg.append("text")
            .attr("font-size","42px")
            .attr("font-family","fangsong")
            .attr("text-anchor","middle")
            .attr("x",w/2)
            .attr("y",50)
            .text("英语单词首字母统计");
			
			
			var rect=svg.selectAll("rect")
			            .data(dataset)
				        .enter()
			            .append("rect")
                          .attr("x",function(d,i){return i*w/dataset.length})
						  .attr("y",function(d){return h-linear(d)})
						  .on("mouseover",function(d,i){
							  d3.select(this)
								.attr("fill",function(){
									var c=2400*percentage[i];
									return d3.rgb(50,200,c).brighter()
								})
								.transition()
                			  	.duration(250)
                			  	.ease("linear")
								.attr("x",function(){return i*w/dataset.length-10})
								.attr("y",function(d){return h-linear(d)-20})
								.attr("width",ww*1.2)
						 		.attr("height",d*1.2);
							  svg.append("text")
							  	 .attr("id","num")
							  	 .attr("x",i*w/dataset.length)
						 		 .attr("y",h-linear(d))
						  		 .attr("dx",ww/2-2)
						  		 .attr("dy","-2em")
						  		 .attr("text-anchor","middle")
								 .attr("font-size","18px")
                          		 .attr("fill",color(i))
								 .text(function(){return dataset[i]});
						  })
						  .on("mouseout",function(d,i){
							  d3.select(this)
							 	.transition()
                			  	.duration(250)
                			  	.ease("linear")
								.attr("fill",function(){
									var c=2400*percentage[i];
									return "rgb(50,200,"+c+")";
								})
								.attr("x",function(){return i*w/dataset.length})
								.attr("y",function(d){return h-linear(d)-15})
								.attr("width",ww*0.8)
						 		.attr("height",linear(d));
							  d3.select("#num")
								.remove();
						  })
						  .attr("width",ww*0.8)
						  .attr("height",0)
						  .attr("fill","black")
 			    		  .transition()
       				      .duration(1000)
						  .delay(function(d,i){
							  return 100*i;
						  })
						  .ease("bounce")
						  .attr("height",function(d){return linear(d)-15})
						  .attr("fill",function(d,i){
							var c=2400*percentage[i];
							return "rgb(50,200,"+c+")";
						});
						  
			svg.selectAll("cha")
        		.data(cha)
            	.enter()
            	.append("text")
            	.attr("font-size","15px")
				.style("stroke", "#336666") 
            	.attr("x",function(d,i){return i*w/dataset.length+10})
				.attr("y",function(d){return h})
            	.text(function(d){
                	return d;
            	});
		
		</script>
		<script>
            var svg2=d3.select("body")
                      .append("svg")
                      .attr("width",w)
                      .attr("height",h);
					  var pie =d3.layout.pie()
            .value(function(d){return d;});
            var piedata=pie(dataset);
			var linear2=d3.scale.linear()
							   .domain([0,d3.max(dataset)])
							   .range([100,400]);
            var arc=d3.svg.arc()
            .innerRadius(100)
            .outerRadius(function(d){
                return linear2(d.value);
            });
            var color=d3.scale.category20();

            svg2.selectAll("path")
            .data(piedata)
            .enter()
            .append("path")
            .attr("stroke","black")
            .attr("transform","translate("+w/2+","+h/1.6+")")
            .on("mouseover",function(d,i){
                d3.select(this)
                .attr("fill",d3.rgb(color(i)).brighter());
                svg2.append("text")
                .attr("id","info")
                .attr("x",w/2)
                .attr("y",h/1.6-15)
                .attr("font-size",30)
                .attr("text-anchor","middle")
                .text(cha[i]);
                svg2.append("text")
                .attr("id","value")
                .attr("x",w/2)
                .attr("y",h/1.6+15)
                .attr("font-size",30)
                .attr("text-anchor","middle")
                .text((percentage[i]*100).toFixed(2)+"%")
            })
            .on("mouseout",function(d,i){
                d3.select(this)
                .transition()
                .duration(500)
                .ease("linear")
                .attr("fill",color(i));
                d3.select("#info")
                .remove();
                d3.select("#value")
                .remove();
            })
            .attr("d",0)
            .attr("fill","black")
            .transition()
			.delay(2600)
            .duration(2000)
            .ease("linear")
            .attr("d",function(d){
                return arc(d)
            })
            .attr("fill",function(d,i){
                return color(i);
            });
            svg2.append("text")
               .attr("font-size","20px")
               .attr("fill","rgb(124,84,57)")
               .attr("font-family","Fantasy")
               .attr("text-anchor","middle")
               .attr("x",w/2)
               .attr("y",h-30)
               .text("18数科 曾锐 李钰林");
			svg2.append("text")
            .attr("font-size","15px")
            .attr("text-anchor","middle")
            .attr("x",w/2)
            .attr("y",h-5)
            .append("svg:a")
            .attr("xlink:href","两大外卖巨头关系图.html")
            .text("点击进入力导向图");   

        </script>
</body>