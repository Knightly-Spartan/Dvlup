({
    fetchQuestions : function(comp) {
        var action = comp.get("c.getQuestions");
        var self = this;
        /* get all the questions from apex controller */
        action.setCallback(this, function(a) {
            if(a.state == "SUCCESS"){
                var questionMap = a.getReturnValue();
                var Questions = [];
                var answers = [];
                comp.set("v.questionMap",questionMap);
                for (var que in questionMap) {
                    Questions.push(que);
                } 
                comp.set("v.Questions",Questions);
                self.setQuesAndAnswer(comp,Questions[0]);
                
            }else{
                var errors = a.getError();
                if (errors) {
                    $A.logf("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        $A.error("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    $A.error("Unknown error");
                }
            } 
        });
        $A.enqueueAction(action);
    },
    
    /* when the question will be changed in picklist, the method will be called */
    changeQuestion : function(comp,evt){
        var self = this;
        var newQuestion = evt.target.value;
        self.setQuesAndAnswer(comp,newQuestion); 
    },
    
    /* this method will set Questions and Answers in component attributes */
    setQuesAndAnswer : function(comp,question){
        var questionMap = comp.get("v.questionMap");
        var answersList = [];
        var self=this;
        var answers = questionMap[question];
        var dataForChart = [];
        var dataForColChart = [];
        var answerMap = new Object();
        for(var i=0;i<answers.length;i++){
            answersList.push(answers[i].pets__Answer__c);
            var votes = answers[i].pets__Voted_By_no_of_users__c == undefined ? 0 : answers[i].pets__Voted_By_no_of_users__c;
            var data = [answers[i].pets__Answer__c,votes];
            answerMap[question+'-'+answers[i].pets__Answer__c] = answers[i].Id;
            dataForChart.push(data);
            
            var colData = new Object();
            colData.name = answers[i].pets__Answer__c;
            colData.data = [votes];
            dataForColChart.push(colData);
        }
        comp.set("v.Question",question);
        comp.set("v.Answers",answersList);
        comp.set("v.answerMap",answerMap);
        
        //call method to draw the Charts
        self.drawPollingChart(comp,question,dataForChart,dataForColChart);
    },
    
    //method to call when user vote for any answer
    increaseVote : function(comp,evt){
        $(".answerRadio").each(function(i) {
            $(this).attr('disabled', 'disabled');
        });
        $(evt.target.parentElement.parentElement).css("background-color","#dff0d8");
        var ans = (evt.target.value);
        
        var que = comp.get("v.Question");
        answerMap = (comp.get("v.answerMap"));
        var ansId = answerMap[que+'-'+ans];
        var self=this;
        var action = comp.get("c.increaseVote");
        action.setParams({
            "answerId": ansId
        });
        var self = this;
        action.setCallback(this, function(a) {
            if(a.state == "SUCCESS"){
                var questionMap = comp.get("v.questionMap");
                var question = comp.get("v.Question");
                var answers = questionMap[question];
                var dataForChart = [];
                var dataForColChart = [];
                for(var i=0;i<answers.length;i++){
                    var data;
                    var colData = new Object();
                    colData.name = answers[i].pets__Answer__c;
                    if(answers[i].Id == ansId){
                        data = [answers[i].pets__Answer__c,parseInt(a.getReturnValue())];
                        colData.data = [parseInt(a.getReturnValue())];
                    }
                    else{
                        var votes = answers[i].pets__Voted_By_no_of_users__c == undefined ? 0 : answers[i].pets__Voted_By_no_of_users__c;
                        data = [answers[i].pets__Answer__c,votes];
                        colData.data = [votes];
                    }
                    dataForChart.push(data);
                    dataForColChart.push(colData);
                }
                self.drawPollingChart(comp,question,dataForChart,dataForColChart);
            }else{
                var errors = a.getError();
                if (errors) {
                    $A.logf("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        $A.error("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    $A.error("Unknown error");
                }
            } 
        });
        
        
        $A.enqueueAction(action);
    },
    
    
    //This method will use highchart api and will draw the charts.
    drawPollingChart : function(comp,question,dataForChart,dataForColChart){
        $('#chartDiv').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: 1,//null,
                plotShadow: false
            },
            title: {
                text: ''
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        //format: '<b>{point.name}</b>: {series.data} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'Vote %',
                data: dataForChart
            }]
        });
        
        /* Column Chart */
        $('#colChartDiv').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: [
                    'Answers',
                    
                ]
                    },
                    yAxis: {
                    min: 0,
                    title: {
                    text: 'Votes'
                    }
                    },
                    tooltip: {
                    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y} </b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                    },
                    plotOptions: {
                    column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                    }
                    },
                    series: dataForColChart
       });  // column chart
    } 
})