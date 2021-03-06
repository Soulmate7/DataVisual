<!DOCTYPE html>
<html>
    <head>
        <title>考研数据可视化分析</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" type="text/css" href="./indexsanji.css" />
        <meta charset="utf-8">
        <style>
        .h1{
            font-size: 100px;
            font-family:"Hanzipen SC","Hannotate SC","Xingkai SC","STFangsong";
            text-align: center;
            margin-top: 5%; 
            margin-left:15%; 
            margin-right: 15% ; 
            margin-bottom: 5%;
        }
        .h2{
            font-size: 35px;
            font-family:"Hanzipen SC","Hannotate SC","Xingkai SC","STFangsong";
            text-align: center;
            color:#3D59AB;
            margin-top: 5%; 
            margin-left:15%; 
            margin-right: 15% ; 
            margin-bottom: 5%;
        }
        .h3{
            font-size: 25px;
            font-family:"Hanzipen SC","Hannotate SC","Xingkai SC","STFangsong";
            text-align: center;
            margin-top: 5%; 
            margin-left:15%; 
            margin-right: 15% ; 
            margin-bottom: 5%;
        }
        .text{
            font-size: 20px;
            font-family:"Yuanti SC";
            margin-left:20%; 
            margin-right: 20% ; 
            margin-bottom: 3%;
            line-height: 30px;
        }
        .province{
                stroke: black;
                stroke-width: 1px;
            }
            .southchinasea{
                stroke: black;
                stroke-width: 1px;
                fill: #ADD8E6;
            }
            .axis path,
          .axis line{
              fill: none;
              stroke: black;
              shape-rendering: crispEdges;
          }
           
          .axis text {
              font-family: sans-serif;
              font-size: 11px;
          }
		.tooltip{  
				position: absolute;  
				width: 240px;  
				height: auto;  
				font-family: simsun;  
				font-size: 11px;
				text-align: left;  
				color: black;  
				border-width: 1px solid black;  
				background-color: white;  
				border-radius: 3px; 
				padding: 6px; 
  letter-spacing:0.5px;
line-height:15px;
			}  
			.tooltip:after{   
				content: '';  
				position: absolute;  
				bottom: 100%;  
				left: 20%;  
				margin-left: -3px;  
				width: 0;  
				height: 0;  
				border-bottom: 12px solid white;  
				border-right: 12px solid transparent;  
				border-left: 12px solid transparent;  
			} 
		
		#myCanvas{
			width: calc(100% - 40px);
			max-width: 650px;
			margin: 1.5rem 25%;
			text-align: center;
		}
		#tooo{
			position:fixed;
			top:50vh;
			left:30vh;
			height:35vh;
			z-index: 1000000;
		}
		#tooo img{
			height: 100%
		}
		.show{
			display: none;
		}
        .axis path,
          .axis line{
              fill: none;
              stroke: black;
              shape-rendering: crispEdges;
          }
           
          .axis text {
              font-family: sans-serif;
              font-size: 11px;
          }
        </style>
    </head>
    <body>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ page language="java" %> 
<%@ page import="com.mysql.jdbc.Driver" %> 
<%@ page import="java.sql.*" %> 
<% 
						//out.print("<center><h1><font color=blue>考研数据可视化分析</h1></center>"); 
						//驱动程序名 
						String driverName="com.mysql.jdbc.Driver"; 
						//数据库用户名 
						String userName="root"; 
						//密码 
						String userPasswd="z1012194891"; 
						//数据库名 
						String dbName="DataVisual"; 
						//表名 
						String tableName="Dataset"; 
						//联结字符串 
						String url="jdbc:mysql://localhost/"+dbName+"?user="+userName+"&password="+userPasswd; 
						Class.forName("com.mysql.jdbc.Driver").newInstance(); 
						Connection connection=DriverManager.getConnection(url); 
						Statement statement = connection.createStatement(); 
						double count[]=new double[10];
						int ss[]=new int[10];
                        String sql="SELECT * FROM "+tableName+" order by id";
						ResultSet rs=statement.executeQuery(sql);
                        
                        int j=0;
                        while(rs.next()){
                            count[j]=rs.getDouble(1);
                            ss[j]=rs.getInt(2);
                            j++;
                        }
                        rs.close();
						statement.close(); 
						connection.close(); 
%>
        <body background="image/back.png"></body>
        <h1 class="h1" style="margin-top: 10%;">考研数据</h1>
        <h1 class="h1">可视化分析</h1>
        <h2 class="h2" style="color: black;">Visual analysis of postgraduate entrance examination data</h2>
        <h3 class="h3" style="margin-top: 5%; margin-bottom: 1%;">👨🏻‍💻 曾锐 李钰林</h3>
        <h3 class="h3" style="margin-top: 0%; margin-bottom: 1%;">📖 数据科学与大数据技术</h3>
        <h3 class="h3" style="margin-top: 0%; margin-bottom: 0%;">📅 2021.6.25</h3>
        <h2 class="h2" style=" margin-top: 15%; ">- 📊 研究背景与目的 -</h2>
        <p  class="text" >
        2015年以来，硕士研究生报名人数屡创新高，2019年达到290万人，2020年首次突破300万，达到341万人。在考生构成中，往届生比例不断提高。据调查显示，考生读研主要动机是获取研究生学历、提升就业和从业的核心竞争力。但不足50%的录取比率也给准备考研的学生带来了不小的压力。
        </p>
        <!--直方图-->
        <script src="d3.v3.min.js" charset="utf-8"></script>
        <script>
            var width=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
            var height=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
            w=width*0.5;
            h=height*0.5;
            var svg=d3.select("body")
            .append("svg")
            .attr("width",width)
            .attr("height",h);
            var tooltip1=d3.select("body")
				.append("div")
				.attr("class","tooltip")
				.style("opacity",0.0);
            svg.append("text")
            .attr("font-size","24px")
            .attr("font-family","Hanzipen SC")
            .attr("text-anchor","middle")
            .attr("x",w/2+width*0.25)
            .attr("y",30)
            .text("历年考研报考及录取人数统计(2012-2021年)");
            svg.append("text")
            .attr("font-size","12px")
            .attr("font-family","Hanzipen SC")
            .attr("text-anchor","middle")
            .attr("x",w/2-30+width*0.25)
            .attr("y",70)
            .text("报考人数");
            svg.append("rect")
            .attr("x",w/2+width*0.25+10)
            .attr("y",60)
            .attr("height",10)
            .attr("width",20)
            .attr("fill","steelblue");
            svg.append("text")
            .attr("font-size","12px")
            .attr("font-family","Hanzipen SC")
            .attr("text-anchor","middle")
            .attr("x",w/2-30+width*0.25)
            .attr("y",85)
            .text("录取人数");
            svg.append("rect")
            .attr("x",w/2+width*0.25+10)
            .attr("y",75)
            .attr("height",10)
            .attr("width",20)
            .attr("fill","rgb(127,255,212)");
            var dataset=new Array(10);
            <%for(int i=0;i<10;i++)
			{%>
				dataset[<%=i%>]=<%=count[i]%>;

			<%}%>
            console.log("test");
            console.log(dataset);
            var colleges=["2012","2013","2014","2015","2016","2017","2018","2019","2020","2021"];
            //var dataset=[165.6000,176.0000,172.0000,164.9000,177.0000,201.0000,238.0000,290.0000,341.0000,377.0000];
            var dataset2=[52.1300,54.0900,54.8700,57.0600,58.9800,72.2200,76.2500,91.6500,111.4000];
            var college=svg.selectAll(".college")
            .data(colleges)
            .enter()
            .append("text")
            .attr("font-size","12px")
            .attr("x",function(d,i){
              return i*(w/colleges.length)+40+width*0.25;
            })
            .attr("y",h-5)
            .text(function(d){
              return d;
            });

            var linear=d3.scale.linear()
            .domain([0,d3.max(dataset)])
            .range([0,h-50]);

            svg.selectAll(".rect")
            .data(dataset)
            .enter()
            .append("rect")
            .attr("x",function(d,i){
              return i*(w/10)+40+width*0.25;
            })
            .attr("y",function(d){
              return h-linear(d)-25;
            })
            .attr("width",(w/10)-60)
            .attr("height",function(d){
              return linear(d);
            })
            .on("mouseover",function(d,i){
                d3.select(this)
                .attr("fill","#B0E0E6");
                tooltip1.html(d+"万")
                        .style("left",(d3.event.pageX)+"px")
                        .style("top",(d3.event.pageY+20)+"px")
                        .style("opacity",1)
                        .style("width","auto");

            })
            .on("mousemove",function(d){
                                    tooltip1.style("left",(d3.event.pageX)+"px")
                                           .style("top",(d3.event.pageY+20)+"px");
                                })
            .on("mouseout",function(d,i){
                tooltip1.style("opacity",0.0);
                d3.select(this)
                .attr("fill","steelblue");
            })
            .attr("fill","steelblue")

            svg.selectAll("data")
            .data(dataset2)
            .enter()
            .append("rect")
            .attr("x",function(d,i){
              return i*(w/10)+40+width*0.25;
            })
            .attr("y",function(d){
              return h-linear(d)-25;
            })
            .attr("width",(w/10)-60)
            .attr("height",function(d){
              return linear(d);
            })
            .on("mouseover",function(d,i){
                d3.select(this)
                .attr("fill","#BDFCC9");
                tooltip1.html(d+"万")
                        .style("left",(d3.event.pageX)+"px")
                        .style("top",(d3.event.pageY+20)+"px")
                        .style("opacity",1)
                        .style("width","auto");
            })
            .on("mousemove",function(d){
                                    tooltip1.style("left",(d3.event.pageX)+"px")
                                           .style("top",(d3.event.pageY+20)+"px");
                                })
            .on("mouseout",function(d,i){
                tooltip1.style("opacity",0.0);
                d3.select(this)
                .attr("fill","rgb(127,255,212)");

            })
            .attr("fill","rgb(127,255,212)");  

            var yScale = d3.scale.linear()
            .domain([0,d3.max(dataset)])
            .range([0,-h+50]);          
            var yAxis=d3.svg.axis()
            .scale(yScale)
            .orient("left");

            svg.append("line")
            .attr("x1",35+width*0.25)
            .attr("y1",h-25)
            .attr("x2",w+width*0.25)
            .attr("y2",h-25)
            .attr("stroke", "black");
            svg.append("g")
            .attr("class","axis")
            .attr("transform","translate("+(35+width*0.25)+","+(h-25)+")")
            .call(yAxis);
            
            
        </script>
        <p class="text" style="margin-top: 5%;">
            随着《国家中长期教育改革和发展规划纲要(2010- -2020年) 》的深入推进和贯彻落实，《学位与研究生教育发展“十三五”规划》继续坚持“服务需求、提高质量”作为研究生教育的发展主线，高校不断提升研究生培养、毕业方面的i门槛，研究生毕业难度和延期率逐年提高，“严进严出” 正在成为研究生教育的关键词。无疑，高质量研究生教育将对国家"双一流"建设起到高端引领和战略支撑的作用,为推动我国由研究生教育大国迈向研究生教育强国提供坚实的基础。
        </p>
        <p class="text">
            通过对研究生招考的各项数据进行可视化，可以直观地看到考研的变化趋势。尤其对于我们2018级的本科生，更能了解自己的目标是什么，应该报考哪些适合自己的院校，如何选择专业等。考生在经过考虑后可以制定相应的方案策略，增加自己上岸的机会。
        </p>
        <h2 class="h2">- 🏫 2020中国考研院校人气四十强排行 -</h2>
        <!--词云图-->
        <script src="d3.layout.cloud.js"></script>
        <script>
            w2=width*0.98;
            h2=height*0.6;
		 var fill = d3.scale.category20();
		 var words=[{text:"南京师范大学",size:50.51740},{text:"苏州大学",size:48.23926},{text:"华东师范大学",size:46.03547},{text:"武汉大学",size:40.64378},
{text:"东华大学",size:39.96762},{text:"南京大学",size:38.87550},{text:"南开大学",size:36.49173},{text:"厦门大学",size:36.24342},
{text:"华中科技大学",size:35.45926},{text:"中南大学",size:34.77292},{text:"北京大学",size:34.25036},{text:"上海大学",size:34.19091},
      {text:"清华大学",size:33.52113},{text:"四川大学",size:33.05628},{text:"郑州大学",size:31.93532},{text:"华中师范大学",size:30.57024},
      {text:"华南师范大学",size:29.92051},{text:"湖南师范大学",size:29.69627},{text:"西安交通大学",size:29.57067},{text:"天津大学",size:28.48719},
      {text:"陕西师范大学",size:27.80969},{text:"北京师范大学",size:27.67637},{text:"重庆大学",size:26.22049},{text:"西北大学",size:24.88220},
      {text:"武汉理工大学",size:24.87279},{text:"浙江大学",size:24.77883},{text:"中国农业大学",size:24.77855},{text:"中国人民大学",size:24.30072},
      {text:"华南理工大学",size:24.27717},{text:"首都师范大学",size:24.16071},{text:"上海交通大学",size:23.74146},{text:"广西大学",size:23.47454},
      {text:"东南大学",size:22.81777},{text:"东北师范大学",size:22.65131},{text:"深圳大学",size:22.56683},{text:"云南大学",size:22.40241},
      {text:"暨南大学",size:22.21407},{text:"南京理工大学",size:21.91337},{text:"吉林大学",size:21.85239},{text:"湖南大学",size:21.54555}];
		 var wc=d3.layout.cloud()
				  .size([w2*0.7, h2*0.8])
				  .words(words)
				  .padding(5)
				  .rotate(function() { return ~~(Math.random() * 2) * 90; })
				  .font("Impact")
				  .fontSize(function(d) { return d.size; })
				  .on("end", draw)
				  .start();

		  function draw(words) {
         var svg=d3.select("body")
            .append("svg")
            .attr("width",w2)
            .attr("height",h2);

			svg.attr("width", w2)
				.attr("height", h2)
			  .append("g")
				.attr("transform", "translate(800,"+h2/1.7+")")
			  .selectAll("text")
				.data(words)
			  .enter().append("text")
				.style("font-size", function(d) { return d.size + "px"; })
				.style("font-family", "Impact")
				.style("fill", function(d, i) { return fill(i); })
				.attr("text-anchor", "middle")
				.attr("transform", function(d) {
				  return "translate(" + [d.x, d.y-100] + ")rotate(" + d.rotate + ")";
				})
				.text(function(d) { return d.text; });


		  }          
        </script>
        <p class="text">
            在考研学校的选择上，考生开始注重学校所在的地理位置，南方高校搜索热度超过北方，一线及新一线城市院校关注度更高，复旦大学、浙江大学、南京大学成为今年广大考研学子热搜高校前三名。
        </p>
        <p class="text">
            而在高校类型的选择上，“双一流”大学仍然是考生们的首选，其中“一流大学建设高校”又更胜于“一流学科建设高校”；但“双非”院校也不可小觑，比如深圳大学的搜索指数超过了厦门大学和北京大学，新锐“黑马”的魅力势不可挡。
        </p>
        <h2 class="h2">- 🎓 中国传媒大学毕业生就业现状分析 -</h2>
        <!--饼图-->
        <script>
            
            w3=width*0.98;
            h3=height*0.8; 
            var svg2=d3.select("body")
            .append("svg")
            .attr("width",w3)
            .attr("height",h3);  

            
            //饼图
            var dataset2=[["签约工作率",18.42],["深造率",34.21],["其他录用形式就业率",10.53],["自由职业率",21.05],["待就业率",10.53],["暂不就业率",5.26]];
            var pie =d3.layout.pie()
            .value(function(d){return d[1];});
            var piedata=pie(dataset2);
            var arc=d3.svg.arc()
            .innerRadius(60)
            .outerRadius(function(d){
                return d.value*5+100;
            });
            var color=d3.scale.category20();

            svg2.selectAll("path")
            .data(piedata)
            .enter()
            .append("path")
            .attr("stroke","blue")
            .attr("transform","translate("+w3/1.3+","+h3/2.5+")")
            .on("mouseover",function(d,i){
                d3.select(this)
                .attr("fill",d3.rgb(color(i)).brighter());
                svg2.append("text")
                .attr("id","info2")
                .attr("x",w3/1.3)
                .attr("y",h3/2.5-15)
                .attr("font-size",15)
                .attr("text-anchor","middle")
                .text(d.data[0]);
                svg2.append("text")
                .attr("id","value")
                .attr("x",w3/1.3)
                .attr("y",h3/2.5+15)
                .attr("font-size",15)
                .attr("text-anchor","middle")
                .text(d.value+"%")
            })
            .on("mouseout",function(d,i){
                d3.select(this)
                .attr("fill",color(i));
                d3.select("#info2")
                .remove();
                d3.select("#value")
                .remove();
            })
            .attr("d",function(d){
                return arc(d)
            })
            .attr("fill",function(d,i){
                return color(i);
            });
            svg2.selectAll("rec")
            .data(piedata)
            .enter()
            .append("rect")
            .attr("transform",function(d,i){
                    return "translate("+(w3/1.8)+","+(h/5+25*i)+")";
            })
            .attr("height",15)
            .attr("width",15)
            .attr("fill",function(d,i){
                return color(i);
            });
            svg2.selectAll("name")
            .data(piedata)
            .enter()
            .append("text")
            .attr("transform",function(d,i){
                    return "translate("+(w3/1.8+20)+","+(h/5+10+25*i)+")";
            })
            .text(function(d){
                return d.data[0]})
            svg2.selectAll("data")
            .data(piedata)
            .enter()
            .append("text")
            .attr("fill","blue")
            .attr("text-anchor","middle")
            .attr("font-size",function(d){
                return d.value*1.2+"px";
            })
            .attr("transform",function(d){
                    var x=arc.centroid(d)[0];
                    var y=arc.centroid(d)[1];
                    return "translate("+(w3/1.3+x)+","+(h3/2.5+y)+")";
            })
            .text(function(d){
                return d.value+"%"})
            svg2.append("text")
            .attr("font-size","18px")
            .attr("font-family","Fantasy")
            .attr("text-anchor","middle")
            .attr("x",w3/1.3)
            .attr("y",h3/1.3-20)
            .text("中国传媒大学2020届本科毕业生");
            svg2.append("text")
            .attr("font-size","18px")
            .attr("font-family","Fantasy")
            .attr("text-anchor","middle")
            .attr("x",w3/1.3)
            .attr("y",h3/1.3+20)
            .text("计算机科学与技术专业（大数据方向）毕业去向");
            svg2.append("text")
            .attr("font-family","Yuanti SC")
            .attr("x",w3/12)
            .attr("y",h3/7)
            .attr("font-size","20px")
            .text("中国传媒大学2020届毕业生就业质量报告中显示，如今计算机科学")
            svg2.append("text")
            .attr("font-family","Yuanti SC")
            .attr("x",w3/12)
            .attr("y",h3/7+30)
            .attr("font-size","20px")
            .text("与技术专业（大数据方向）的毕业生深造率已高达34%，读研似乎")
            svg2.append("text")
            .attr("font-family","Yuanti SC")
            .attr("x",w3/12)
            .attr("y",h3/7+60)
            .attr("font-size","20px")
            .text("已经成为了毕业生们的首选。而剩下的同学大多选择了就业，且比")
            svg2.append("text")
            .attr("font-family","Yuanti SC")
            .attr("x",w3/12)
            .attr("y",h3/7+90)
            .attr("font-size","20px")
            .text("率并不低，这说明考研并不是所有同学的首选项。")
            //直方图2
            companies=["腾讯","字节跳动","京东","网易","百度","华为","苏宁","小米","新浪","阿里巴巴"]
            data2=[84,54,37,35,25,24,17,16,14,11];
            svg2.append("text")
            .attr("font-size","15px")
            .attr("x",w3/8)
            .attr("y",h3/2.1)
            .attr("fill","green")
            .text("💴接收中国传媒大学近三年毕业生人数前 10 位的互联网百强企业");
            svg2.selectAll("company")
            .data(companies)
            .enter()
            .append("text")
            .attr("font-size","12px")
            .attr("text-anchor","middle")
            .attr("x",function(d,i){
                return w/4.5+i*50;
            })
            .attr("y",h3/1.2-30)
            .text(function(d){
                return d;
            });
            svg2.append("line")
            .attr("x1",w/6+10)
            .attr("y1",h3/1.3)
            .attr("x2",w-160)
            .attr("y2",h3/1.3)
            .attr("stroke", "steelblue");
            svg2.selectAll("data2")
            .data(data2)
            .enter()
            .append("rect")
            .attr("x",function(d,i){
                return w3/10+i*50;
            })
            .attr("y",function(d){
                return h3/1.3-d*2;
            })
            .attr("fill",function(d,i)
            {
                var c=240-data2[i];
                return "rgb(127,255,"+c+")";
            })
            .on("mouseover",function(d,i){
                d3.select(this)
                .attr("fill","green");
                svg2.append("text")
                .attr("id","num")
                .attr("x",w3/10+20+i*50)
                .attr("y",h3/1.3-data2[i]*2)
                .attr("text-anchor","middle")
                .attr("font-size","12px")
                .attr("fill","green")
                .text(data2[i]);
            })
            .on("mouseout",function(d,i){
                d3.select(this)
                .attr("fill",function(){
                    var c=240-data2[i];
                    return "rgb(127,255,"+c+")";
                })
                d3.select("#num")
                .remove();
            })
            .attr("width",40)
            .attr("height",function(d){
                return d*2;
            });
        </script>
        <h2 class="h2">- ⛩ 各省硕士研究生招生考试报名人数及大学分布图 -</h2>
        <!--地图-->
        <script>
            w4=width*0.98;
            h4=height*0.8;
            var svg4=d3.select("body")
                      .append("svg")
                      .attr("width",w4)
                      .attr("height",h4);

            //甘肃，青海，广西，贵州，重庆，北京，福建，安徽，广东，西藏，新疆，海南，宁夏，陕西
            //山西，湖北，湖南，四川，云南，河北，河南，辽宁，山东，天津，江西，江苏，上海，浙江，吉林，内蒙古，黑龙江，香港，澳门，台湾
            var nums=[6.8,0.8,6.4,5.8,13.9,13.8,5.8,17.5,20.2,0.3,5.0,2.4,1.1,14.2,
                      14,16.28,12.2,21.7,4.9,14.7,30.2,12.9,34.8,6.8,9.6,26.3,6,12.5,8.0,8.2,10.7,0,0,0];
            var margin= { top: 30, right: 0, bottom: 30, left: 40 };
            var schools=[49,12,74,70,65,92,89,119,151,7,47,19,19,93,80,129,124,109,77,121,134,115,145,57,100,167,64,107,62,53,81,10,12,159];
            var highschool=[2,1,1,1,3,34,3,4,6,1,2,1,1,11,1,9,7,7,1,1,1,6,5,5,1,13,14,2,4,1,5,0,0,0];
            var tooltip=d3.select("body")
				.append("div")
				.attr("class","tooltip")
				.style("opacity",0.0);
            
            var projection=d3.geo.mercator()
                                 .center([116,40])
                                 .scale(800)
                                 .translate([w4/2+100,h4/2.5]);

            var color2=d3.scale.linear()
                        .domain([0,d3.max(nums)])
                        .range(['#F0FFFF','#00BFFF']);
            var color3=d3.scale.linear()
                        .domain([0,d3.max(highschool)])
                        .range(['#DDA0DD','#9933FA']);

            var linear3=d3.scale.linear()
                          .domain([0,d3.max(highschool)])
                          .range([2,10]);
            var txtcolor=d3.scale.linear()
                           .domain([0,d3.max(nums)])
                           .range(['#6495ED','#000080']);

            var path=d3.geo.path()
                           .projection(projection);

            d3.json("map/China.geojson",function(error,geo){
                console.log(geo);
                
                var province=svg4.selectAll(".province")
                                .data(geo.features)
                                .enter()
                                .append("path")
                                .attr("class","province")
                                .attr("fill",function(d,i){
                                    return color2(nums[i]);
                                })
                                .attr("d",path)
                                .on("mouseover",function(d,i){
                                    d3.select(this)
                                      .attr("fill","#00CED1");
                                    tooltip.html("省市:"+d.properties.name+"<br/>考研报名人数:"+nums[i]+"万人<br/>"+"大学数量:"+schools[i]+"<br/>985、211高校数量:"+highschool[i])
                                           .style("left",(d3.event.pageX)+"px")
                                           .style("top",(d3.event.pageY+20)+"px")
                                           .style("opacity",1);
                                    tooltip.style("box-shadow","10px 0px 0px"+color2(nums[i]));
                                })
                                .on("mousemove",function(d){
                                    tooltip.style("left",(d3.event.pageX)+"px")
                                           .style("top",(d3.event.pageY+20)+"px");
                                })
                                .on("mouseout",function(d,i){
                                    tooltip.style("opacity",0.0);
                                    d3.select(this)
                                      .attr("fill",function(){
                                        return color2(nums[i]);
                                      })
                                });

                var label=svg4.selectAll(".label")
                             .data(geo.features)
                             .enter()
                             .append("text")
                             .attr("class","label")
                             .text(function(d){
                                 return d.properties.name;
                             })
                             .attr("transform",function(d,i){
                                var center=path.centroid(d);
                                var x=center[0],y=center[1];
                                if((d.properties.name=="河北")||(d.properties.name=="澳门")||(d.properties.name=="安徽"))
											y=y+25;
                                return "translate("+x+","+y+")"; 
                             })
                             .attr('fill','#4682B4')
							 .attr("font-size","12px");

                var school=svg4.selectAll("circle")
                             .data(geo.features)
                             .enter()
                             .append("circle")
                             .attr("cx",function(d,i){
                                var center=path.centroid(d);
                                var cx=center[0];
                                return cx-5;
                             })
                             .attr("cy",function(d,i){
                                var center=path.centroid(d);
                                var cy=center[1];
                                if((d.properties.name=="河北")||(d.properties.name=="澳门")||(d.properties.name=="安徽"))
											cy=cy+25;
                                return cy;
                             })
                             .attr("opacity",0.8)
                             .attr("fill",function(d,i){
                                 return color3(highschool[i])
                             })
                             .attr("r",function(d,i){
                                 return linear3(highschool[i]);
                             })
            });
            var linearGradient=svg4.append("defs")
                                   .append("linearGradient")
                                   .attr("id","linearColor")
                                   .attr("x1","0%")
                                   .attr("y1","100%")
                                   .attr("x2","0%")
                                   .attr("y2","0%")

            linearGradient.append("stop")
                          .attr("offset","0%")
                          .attr("stop-color",'#F0FFFF');
            
            linearGradient.append("stop")
                          .attr("offset","100%")
                          .attr("stop-color",'#00BFFF');
            
            
            
            d3.xml("map/southchinasea.svg",function(error,xmlDocument){
                console.log(xmlDocument);

                svg4.html(function(d){
                    return d3.select(this).html()+ xmlDocument.getElementsByTagName("g")[0].outerHTML;
                });

                d3.select("#southchinasea")
                  .attr("transform","translate("+w4/1.5+",600) scale(0.5)")
                  .attr("class","southchinasea");

            });

            svg4.append("rect")
                .attr("x",w4/5)
                .attr("y",600)
                .attr("width",16)
                .attr("height",83)
                .style("fill","url(#"+linearGradient.attr("id")+")");
            
            svg4.append("text")
                .attr("fill","steelblue")
                .attr("x",w4/5+20)
                .attr("y",683)
                .text(0)
                .classed("linear-text",true);
            svg4.append("text")
                .attr("fill","steelblue")
                .attr("x",w4/5+20)
                .attr("y",600)
                .text(d3.max(nums))
                .classed("linear-text",true);
            svg4.append("text")
                .attr("fill","steelblue")
                .attr("x",w4/5-100)
                .attr("y",600)
                .text("考研人数(万)")
                .classed("linear-text",true);
        </script>
        <p class="text">
            在地图中，每个省市的填充颜色深浅代表了这个此省市报名硕士研究生招生考试的人数多少，从地图中我们可以看出，山东、河南、四川以及广东这些人口大省的考研人数较多。而地图上圆圈大小及颜色深浅则表示了这个省市有多少985、211高校。从图中我们可以看到一些考研大省，他们的高校数量并不是很多，甚至在考研大省河南省只有一个985、211，这一定程度上也造成了河南省的人才外流。相比而言，北京市的高校数量在全国遥遥领先，无数本科毕业生的考研首选地区就是北京。
        </p>
        <h2 class="h2">- 📈 近五年考研国家分数线及趋势图 -</h2>
        <!--散点折线图-->
        <script src="https://d3js.org/d3.v4.min.js"></script>
        <script>
            var svg5=d3.select("body")
                       .append("svg")
                       .attr("width",w2)
                       .attr("height",h2*0.8);
            var padding = { top: 50, right: 50, bottom: 50, left: 50 };
            var xueshuoA=[{x:2017,y:265},{x:2018,y:260},{x:2019,y:270},{x:2020,y:264},{x:2021,y:263}];
            var xueshuoB=[{x:2017,y:255},{x:2018,y:250},{x:2019,y:260},{x:2020,y:254},{x:2021,y:253}];


            var xScale2 = d3.scaleLinear()
                                  .domain([2016,2022])
                                  .range([0,w2*0.25]);

            var xAxis2=d3.axisBottom()
                         .ticks(5)
                         .tickSize(2,4)
                         .tickValues([2017,2018,2019,2020,2021])
                         .tickFormat(d3.format("1.0f"))
                         .scale(xScale2);
            var yScale2= d3.scaleLinear()
                           .domain([240,275])
                           .range([0,-h2*0.5]); 
            var yAxis2 = d3.axisLeft()
							.scale(yScale2);

            svg5.append("g")
                .attr("class","axis")
                .attr("transform","translate("+w2/5+","+h2/1.5+")")
                .call(xAxis2);
            svg5.append("g")
                .attr("class","axis")
                .attr("transform","translate("+w2/5+","+h2/1.5+")")
                .call(yAxis2);

            var lineGen=d3.svg.line()
                        .x(function(d){
                            return xScale2(d.x);
                        })
                        .y(function(d){
                            return yScale2(d.y);
                        });
            svg5.append('path')
                .attr('d', lineGen(xueshuoA))
                .attr("transform","translate("+w2/5+","+h2/1.5+")")
                .attr('stroke', '#1E90FF')
                .attr('stroke-width', 2)
                .attr('fill', 'none');
            svg5.append('path')
                .attr('d', lineGen(xueshuoB))
                .attr("transform","translate("+w2/5+","+h2/1.5+")")
                .attr('stroke', '#B22222')
                .attr('stroke-width', 2)
                .attr('fill', 'none');
            svg5.append("g")
                .selectAll('circle')
                .data(xueshuoA)
                .enter()
                .append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/5+ xScale2(d.x))  + ',' + (h2/1.5+yScale2(d.y))  + ')';
                })
                .attr('fill', '#1E90FF');
            svg5.append("g")
                .selectAll('circle')
                .data(xueshuoB)
                .enter()
                .append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/5+ xScale2(d.x))  + ',' + (h2/1.5+yScale2(d.y))  + ')';
                })
                .attr('fill', '#B22222');
            svg5.append("g")
                .selectAll("num")
                .data(xueshuoA)
                .enter()
                .append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/5+ xScale2(d.x)-10)  + ',' + (h2/1.5+yScale2(d.y)-10)  + ')';
                })
                .attr("font-size","12px")
                .text(function(d){
                    return d.y;
                })
            svg5.append("g")
                .selectAll("num")
                .data(xueshuoB)
                .enter()
                .append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/5+ xScale2(d.x)-10)  + ',' + (h2/1.5+yScale2(d.y)-10)  + ')';
                })
                .attr("font-size","12px")
                .text(function(d){
                    return d.y;
                })
            svg5.append("g")
                .selectAll("title")
                .data(xueshuoA)
                .enter()
                .append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/5)  + ',' + (h2/12)  + ')';
                })
                .attr("font-size","20px")
                .text("工学学硕（不含工学照顾专业）总分国家线趋势图");
            svg5.append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/4+100)+ ',' +(h2/12+30)+ ')';
                })
                .attr('fill', '#1E90FF');
            svg5.append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/4+100)+ ',' +(h2/12+50)+ ')';
                })
                .attr('fill', '#B22222');
            svg5.append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/4+110)  + ',' + (h2/12+35)  + ')';
                })
                .attr("font-size","12px")
                .text("A类考生");
            svg5.append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/4+110)  + ',' + (h2/12+55)  + ')';
                })
                .attr("font-size","12px")
                .text("B类考生");
            //专硕图
            var zhuanshuoA=[{x:2020,y:264},{x:2021,y:263}];
            var zhuanshuoB=[{x:2020,y:254},{x:2021,y:253}];
            var xScale3 = d3.scaleLinear()
                                  .domain([2019,2022])
                                  .range([0,w2*0.25]);

            var xAxis3=d3.axisBottom()
                         .ticks(4)
                         .tickSize(2,3)
                         .tickValues([2020,2021])
                         .tickFormat(d3.format("1.0f"))
                         .scale(xScale3);
            svg5.append("g")
                .attr("class","axis")
                .attr("transform","translate("+w2/1.7+","+h2/1.5+")")
                .call(xAxis3);
            svg5.append("g")
                .attr("class","axis")
                .attr("transform","translate("+w2/1.7+","+h2/1.5+")")
                .call(yAxis2);

            var lineGen2=d3.svg.line()
                        .x(function(d){
                            return xScale3(d.x);
                        })
                        .y(function(d){
                            return yScale2(d.y);
                        });
            svg5.append('path')
                .attr('d', lineGen2(zhuanshuoA))
                .attr("transform","translate("+w2/1.7+","+h2/1.5+")")
                .attr('stroke', '#1E90FF')
                .attr('stroke-width', 2)
                .attr('fill', 'none');
            svg5.append('path')
                .attr('d', lineGen2(zhuanshuoB))
                .attr("transform","translate("+w2/1.7+","+h2/1.5+")")
                .attr('stroke', '#B22222')
                .attr('stroke-width', 2)
                .attr('fill', 'none');
            svg5.append("g")
                .selectAll('circle')
                .data(zhuanshuoA)
                .enter()
                .append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.7+ xScale3(d.x))  + ',' + (h2/1.5+yScale2(d.y))  + ')';
                })
                .attr('fill', '#1E90FF');
            svg5.append("g")
                .selectAll('circle')
                .data(zhuanshuoB)
                .enter()
                .append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.7+ xScale3(d.x))  + ',' + (h2/1.5+yScale2(d.y))  + ')';
                })
                .attr('fill', '#B22222');
            svg5.append("g")
                .selectAll("num")
                .data(zhuanshuoA)
                .enter()
                .append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.7+ xScale3(d.x)-10)  + ',' + (h2/1.5+yScale2(d.y)-10)  + ')';
                })
                .attr("font-size","12px")
                .text(function(d){
                    return d.y;
                })
            svg5.append("g")
                .selectAll("num")
                .data(zhuanshuoB)
                .enter()
                .append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.7+ xScale3(d.x)-10)  + ',' + (h2/1.5+yScale2(d.y)-10)  + ')';
                })
                .attr("font-size","12px")
                .text(function(d){
                    return d.y;
                })
            svg5.append("g")
                .selectAll("title")
                .data(zhuanshuoA)
                .enter()
                .append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.7)  + ',' + (h2/12)  + ')';
                })
                .attr("font-size","20px")
                .text("工学专硕（不含建筑学、城市规划）总分国家线趋势图");
            svg5.append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.5+100)+ ',' +(h2/12+30)+ ')';
                })
                .attr('fill', '#1E90FF');
            svg5.append('circle')
                .attr('r', 4)
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.5+100)+ ',' +(h2/12+50)+ ')';
                })
                .attr('fill', '#B22222');
            svg5.append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.5+110)  + ',' + (h2/12+35)  + ')';
                })
                .attr("font-size","12px")
                .text("A类考生");
            svg5.append("text")
                .attr('transform', function(d){
                        return 'translate(' +(w2/1.5+110)  + ',' + (h2/12+55)  + ')';
                })
                .attr("font-size","12px")
                .text("B类考生");
        </script>
        <p class="text">
            从近几年工学的考研分数线来看，2019年的学硕考研分数线大幅上涨，但在2020年又立即回落，并逐渐平稳：A类考生的国家线分数在大体上趋于265分左右；B类考生的国家线分数在大体上趋于255分左右。而工学专硕分数线在这两年趋于平稳。
        </p>
        <!--桑基图-->
        <h2 class="h2">- 🕹 热门专业的选择 -</h2>
        <center>
            <a href="indexsanji.html" class="h3" target="_blank">2021考研报考专业人气榜</a>
        </center>
        <p class="text">通过桑基图可以看到，选择管理学的同学最多，在其子类专业中，会计学独占鳌头，其次是行政管理和企业管理。在管理学之外，选择计算机应用技术的同学最多，而选座思想政治教育的较少。</p>
        <!--三维图-->
        <h2 class="h2">- 🏫 全国高校A+专业分布3D图 -</h2>
        <center>
            <a href="三维直方图/index.html" class="h3" target="_blank">点击查看3D地图</a>
        </center>
        <p class="text">
            从中可以看出，北京一枝独秀，A+学科数目几乎占据了半壁江山，不愧是中国的文化中心。上海和江苏紧随其后，说明长三角地区教育总体较珠三角更为发达。武汉虽然高校数量最多，但总共只有14个A+学科，有种大而不精的感觉。此后浙江的13个A+（11个来自浙大，2个来自中国美术学院），安徽的7个A+（全部来自中科大），湖南的7个A+（3个来自中南，4个来自国防科大）。
        </p>
        <h2 class="h2">- 🚩 分析结论 -</h2>
        <p class="text">
            通过对考研各个方面数据的可视化，我们分别得到了直方图，词云图，玫瑰图，地图，折线图以及桑基图。根据这些图表我们可以清楚地对当前考研形势进行分析，有效揭示了考研的客观规律和考研数据的内在联系，呈现数据的重要特征，有利于提高对考研的理解，获取更多的详细信息。
        </p>
        <p class="text">
            毫无疑问，2022届的考研人数必然还会增长，考研已经成为了大多数本科毕业生的主流选择。爆炸增长的考研人数与增长率较低的录取比率形成的矛盾，势必会带给往后考研人巨大的压力。在考研院校的选择上，双一流高校依旧是考生们的首选，复旦大学则成为了今年考研高校的“热搜”头名。
        </p>
        <p class="text">
            但考研并非是本科毕业生的唯一出路，也有不少毕业生选择了就业。以中传计算机专业为例，没有选择深造的占比约66%，以各种形式选择就业的就有50%。且在中国传媒大学，毕业后进入国内前10位互联网百强企业的人数并不少，所以能力强的同学完全不必纠结和担心自己的毕业去向，“是金子在哪里都会发光”。
        </p>
        <p class="text">
            对于选择考研的同学来说，可以选择报考北京、上海、江苏、湖北等地区的高校，这些地方的高校数量在全国名列前茅，且就业资源丰富，但同时也面临着更大的考试压力。对于工科生来说，最近两年的国家分数线较为稳定，相对于其他专业分数较低，但还是要根据自己心仪的院校分数线来选择报考哪所高校。
        </p>
        <p class="text">
            不同于高考，考研更像是一个人的奋斗。既然选择了这条路，那么无论累与苦，都要坚持走下去。种下的种子，辛苦耕耘后终会开出一朵美丽的花。
        </p>
        <p class="text">
            祝2022届考研人们好运，祝我们好运。
        </p>
        <center>
            <img src="end.png" width="274" height="486">
        </center>
        
    </body>
</html>