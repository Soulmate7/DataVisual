import Chart from "./chart.js";

d3.json('./datasanji.json').then(function(data){

    /* ----------------------------配置参数------------------------  */
    const chart = new Chart();
    const config = {
        margins: {top: 200, left: 250, bottom: 50, right: 50},
        textColor: 'black',
        title: '2021考研报考专业人气榜'
    }

    chart.margins(config.margins);

    /* ----------------------------数据转换------------------------  */
    const sankey = d3.sankey()
                        .nodeWidth(100)
                        .nodePadding(10)
                        .size([chart.getBodyWidth(), chart.getBodyHeight()])
                        .nodeId((d) => d.id);

    const {nodes, links} = sankey({
                                nodes: data.nodes,
                                links: data.links
                            });

    /* ----------------------------渲染节点------------------------  */
    chart.renderNodes = function(){
        const rects = chart.body().append('g')
                                  .attr('class', 'rects')
                                  .selectAll('.node')
                                  .data(nodes);

              rects.enter()
                     .append('g')
                     .attr('class', 'node')
                     .attr('index', (d)=> d.id)
                     .attr('linkNodes', (d)=> {
                         const nextNodes = d.sourceLinks.map((link) => link.target.id).join('');
                         const prevNodes = d.targetLinks.map((link) => link.source.id).join('');
                         return nextNodes + d.id + prevNodes;
                     })
                     .append('rect')
                   .merge(rects)
                     .attr('x', (d) => d.x0)
                     .attr('y', (d) => d.y0)
                     .attr('width', (d) => d.x1 - d.x0)
                     .attr('height', (d) => d.y1 - d.y0)
                     .attr('fill', (d) => chart._colors(d.id % 10));

              rects.exit()
                     .remove();

    }

    /* ----------------------------渲染连线------------------------  */
    chart.renderLines = function(){
        const lines = chart.body().append('g')
                                  .attr('class', 'lines')
                                  .selectAll('path')
                                  .data(links);

               lines.enter()
                      .append('path')
                    .merge(lines)
                      .attr('linkNodes', (d) => d.source.id + '-' + d.target.id)
                      .attr('d', d3.sankeyLinkHorizontal())
                      .attr('stroke', (d) => chart._colors(d.source.index % 15))
                      .attr('stroke-width', (d) => d.width)
                      .attr('stroke-opacity', '0.8')
                      .attr('fill', 'none');

               lines.exit()
                      .remove();
    }

    /* ----------------------------渲染文本标签------------------------  */
    chart.renderTexts = function(){
        d3.selectAll('.text').remove();

        chart.body().selectAll('.node')
                        .append('text')
                        .attr('class', 'text')
                        .attr('x', (d) => (d.x0 + d.x1)/2)
                        .attr('y', (d) => (d.y0 + d.y1)/2)
                        .attr('stroke', config.textColor)
                        .attr('text-anchor', 'middle')
                        .attr('dy', 6)
                        .text((d) => d.values);
    }

    /* ----------------------------渲染图标题------------------------  */
    chart.renderTitle = function(){
        chart.svg().append('text')
                .classed('title', true)
                .attr('x', chart.width()/2)
                .attr('y', 0)
                .attr('dy', '2em')
                .text(config.title)
                .attr('fill', config.textColor)
                .attr('text-anchor', 'middle')
                .attr('stroke', config.textColor);

    }

    /* ----------------------------绑定鼠标交互事件------------------------  */
    chart.addMouseOn = function(){

        // 悬停在节点上
        d3.selectAll('.node')
            .on('mouseover', function(d){
                d3.selectAll('.node, path')
                    .attr('fill-opacity', '1')
                    .attr('stroke-opacity', '1');



            })
            .on('mouseleave', function(){
                d3.selectAll('.node, path')
                    .attr('fill-opacity', '1')
                    .attr('stroke-opacity', '1');
            })

        // 悬停在连线上
        d3.selectAll('path')
            .on('mouseover', function(){
                d3.selectAll('.node, path')
                    .attr('fill-opacity', '1')
                    .attr('stroke-opacity', '0.8');

                const e = d3.event;
                const hoverNodes = d3.select(e.target)
                                        .attr('stroke-opacity', '0.4')
                                        .attr('linkNodes').split('-');

            })
            .on('mouseleave', function(){
                d3.selectAll('.node, path')
                    .attr('fill-opacity', '1')
                    .attr('stroke-opacity', '0.8');
            })
    }

    chart.render = function(){

        chart.renderTitle();

        chart.renderNodes();

        chart.renderLines();

        chart.renderTexts();

        chart.addMouseOn();
    }

    chart.renderChart();


});