//
//= require jquery
//= require jquery_ujs
//= require underscore
//= require jquery.knob
//= require habits
//= require twitter/bootstrap
//= require bootstrap-tour

var ui = {

    // Render the Calendar
    "renderCalendar" : function(mm,yy){
        
        // HTML renderers
        var _html = "";
        var cls = "";
        var msg = "";
        var id = "";
        
        // Create current date object
        var now = new Date();
        
        // Defaults
        if(arguments.length == 0){
            mm = now.getMonth();
            yy = now.getFullYear();
        }
        
        // Create viewed date object
        var mon = new Date(yy,mm,1);
        var yp=mon.getFullYear();
        var yn=mon.getFullYear();
        
        var prv = new Date(yp,mm-1,1);
        var nxt = new Date(yn,mm+1,1);
        
        var m = [
             "January"
            ,"February"
            ,"March"
            ,"April"
            ,"May"
            ,"June"
            ,"July"
            ,"August"
            ,"September"
            ,"October"
            ,"November"
            ,"December"
        ];

        var d = [
             "S"
            ,"M"
            ,"T"
            ,"W"
            ,"Th"
            ,"F"
            ,"S"
        ];
        
        // Days in Month
        var n = [
             31
            ,28
            ,31
            ,30
            ,31
            ,30
            ,31
            ,31
            ,30
            ,31
            ,30
            ,31
        ];
    
        // Leap year
        if(now.getYear()%4 == 0){
            n[1] = 29;
        }
        
        // Get some important days
        var fdom = mon.getDay(); // First day of month
        var mwks = 6 // Weeks in month
        
        // Render Month
        $('.year').html(mon.getFullYear());
        $('.month').html(m[mon.getMonth()]);
        
        // Clear view
        var h = $('#calendar > thead:last');
        var b = $('#calendar > tbody:last');
        
        h.empty();
        b.empty();
        
        // Render Days of Week
        for(var j=0;j<d.length;j++){
            _html += "<th>" +d[j]+ "</th>";
        }
        _html = "<tr>" +_html+ "</tr>";
        h.append(_html);
        
        // Render days
        var dow = 0;
        var first = 0;
        var last = 0;
        for(var i=0;i>=last;i++){
            
            _html = "";
            
            for(var j=0;j<d.length;j++){
                
                cls = "";
                msg = "";
                id = "";
                
                // Determine if we have reached the first of the month
                if(first >= n[mon.getMonth()]){
                    dow = 0;
                }else if((dow>0 && first>0) || (j==fdom)){
                    dow++;
                    first++;
                }
                
                // Format Day of Week with leading zero
                dow = "0" + dow;
                
                // Get last day of month
                if(dow==n[mon.getDate()]){
                    last = n[mon.getDate()];
                }        
                
                // Set class
                if(cls.length == 0){
                    if(
                        dow==now.getDate() 
                        && now.getMonth() == mon.getMonth() 
                        && now.getFullYear() == mon.getFullYear()
                    ){
                        cls = "today";
                    }else if(j == 0 || j == 6){
                        cls = "weekend";
                    }else{
                        cls = "";
                    }
                }
                
                // Set ID
                //id = "cell_" + i + "" + j + "" + dow;
                id = new Date(mon.getFullYear(), mon.getMonth(), dow).toDateString().replace(/ /gi, '-')
                
                // Render HTML
                if(dow == 0){
                    _html += '<td>&nbsp;</td>';
                }else if(msg.length > 0){
                    _html += '<td class="' +cls+ '" id="'+id+'" data-dow="' + dow.substr(-2) + '">' + dow.substr(-2) + '<br/><span class="content">'+msg+'</span></td>';
                }else{
                    _html += '<td class="' +cls+ '" id="'+id+'" data-dow="' + dow.substr(-2) + '">' + dow.substr(-2) + '<div class="cal-data">&nbsp;</div></td>';
                }
                
            }
            
            _html = "<tr>" +_html+ "</tr>";
            b.append(_html);
        }
        
        $('#last').unbind('click').bind('click',function(){
            ui.renderCalendar(prv.getMonth(),prv.getFullYear());
        });
        
        $('#current').unbind('click').bind('click',function(){
            ui.renderCalendar(now.getMonth(),now.getFullYear());
        });
        
        $('#next').unbind('click').bind('click',function(){
            ui.renderCalendar(nxt.getMonth(),nxt.getFullYear());
        });
        
        
    },
    
    
    // Initialization
    "init" : function(){
    }
    
};


// Initialize
ui.init();


// Load
$(document).ready(function(){
        
    // Render the calendar
    ui.renderCalendar();
    
});
