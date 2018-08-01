

var $error = $("#dod-error");
var  $formcustsignin = $(".form-custsignin"),  $formvendsignin = $(".form-vendorsignin");

var opts = {
  lines: 13 // The number of lines to draw
, length: 28 // The length of each line
, width: 14 // The line thickness
, radius: 42 // The radius of the inner circle
, scale: 1 // Scales overall size of the spinner
, corners: 1 // Corner roundness (0..1)
, color: '#000' // #rgb or #rrggbb or array of colors
, opacity: 0.25 // Opacity of the lines
, rotate: 0 // The rotation offset
, direction: 1 // 1: clockwise, -1: counterclockwise
, speed: 1 // Rounds per second
, trail: 60 // Afterglow percentage
, fps: 20 // Frames per second when using setTimeout() as a fallback for CSS
, zIndex: 2e9 // The z-index (defaults to 2000000000)
, className: 'spinner' // The CSS class to assign to the spinner
, top: '50%' // Top position relative to parent
, left: '50%' // Left position relative to parent
, shadow: false // Whether to render a shadow
, hwaccel: false // Whether to use hardware acceleration
, position: 'fixed' // Element positioning
};
var $busyindicator = document.getElementById('busy-indicator')
var spinner = new Spinner(opts).spin();

$busyindicator.appendChild(spinner.el);

$(document).ready(function () {
        $('#reg-type').change(function () {
            if ($('#reg-type').val() == 'CUS') {
                $('#housenum').show();
            }
            else {
                $('#housenum').hide();
            }
        });
    });

$(document).ready(function() {
        $('[data-toggle="tooltip"]').tooltip({'placement': 'top'});
});

$(document).ready (function(){
    $('.up').on('click',function(){
	$('.input-quantity').val(parseInt($('.input-quantity').val())+1);
    });
});

$(document).ready (function(){
    $('.down').on('click',function(){
	if($('.input-quantity').val() == 0) return false; 
	$('.input-quantity').val(parseInt($('.input-quantity').val())-1);
    }); 
});




$(document).ready(function () {
    $.ajaxSetup({
    	beforeSend: function(){
           // $('<div class=loadingDiv>loading...</div>').prependTo(document.body);
	    $busyindicator.appendChild(spinner.el);

	},
	complete: function(){
   	    $busyindicator.removeChild(spinner.el);
	}
    });
});

window.onload = function (e){
    $busyindicator.removeChild(spinner.el);
}





function countChar(val, maxchars){
var length = val.value.length; 
    if (length >= maxchars){
	val.value = val.value.substring(0, maxchars); 
    }else {
	$('#charcount').text (maxchars - length)
	}
}; 



$formcustsignin.submit ( function() {
    $formcustsignin.hide();
    $.ajax({
	type: "POST",
	url: $formcustsignin.attr("action"),
	data: $formscustignin.serialize(),
	error:function(){
	$error.show();
	},
   	success: function(response){
	    console.log("Customer Signin successful");
	    window.location = "/dodcustindex"; 
	    location.reload(); 

	}
    })
    return false;
    
})

$(document).ready(
    
    function() {
        $( "#required-on" ).datepicker({dateFormat: "dd/mm/yy", minDate: 1} ).attr("readonly", "true");
        }
);



$formvendsignin.submit ( function() {
    $formvendsignin.hide();
    $.ajax({
	type: "POST",
	url: $formsignin.attr("action"),
	data: $formvendsignin.serialize(),
	error:function(){
	$error.show();
	},
   	success: function(response){
	    console.log("Vendor Signin successful");
	    window.location = "/dodvendindex";  
	    location.reload(); 

	}
    })
    return false;
    
})



$(".form-product").on('submit', function (e) {
    var theForm = $(this);
    $(theForm).find("button[type='submit']").hide(); //prop('disabled',true);
      $.ajax({
            type: 'POST',
          url: $(theForm).attr("action"), 
            data: $(theForm).serialize(),
            success: function (response) {
		console.log("Added a product to cart");
		location.reload();
            }
      });
      e.preventDefault();});

	    
$(".form-shopcart").on('submit', function (e) {
    var theForm = $(this);
    $(theForm).find("button[type='submit']").hide(); //prop('disabled',true);
      $.ajax({
            type: 'POST',
          url: $(theForm).attr("action"), 
            data: $(theForm).serialize(),
            success: function (response) {
		console.log("Updated shopping cart");
		location.reload();

            }
      });
      e.preventDefault();});	
	


$(document).ready(function () {

    $(window).scroll(function () {
        if ($(this).scrollTop() > 100) {
            $('.scrollup').fadeIn();
        } else {
            $('.scrollup').fadeOut();
        }
    });

    $('.scrollup').click(function () {
        $("html, body").animate({
            scrollTop: 0
        }, 600);
        return false;
    });

});

function goBack (){
    window.history.back();
}



function CancelConfirm (){
    return confirm("Do you really want to Cancel?");
}

function DeleteConfirm (){
    return confirm("Do you really want to Delete?");
}





$(document).ready(function(){
    $("#livesearch").keyup(function(){
	if (($("#livesearch").val().length ==3) || 
	    ($("#livesearch").val().length == 5)||
	    ($("#livesearch").val().length == 8)||
	    ($("#livesearch").val().length == 13)||
	    ($("#livesearch").val().length == 21)){
	    $.ajax({
		type: "post", 
		cache: false,
		url: $(theForm).attr("action"), 
		data: $(theForm).serialize(),
		success: function(response){
		  
		   //document.getElementById("livesearch").innerHTML=this.responseText;
		//document.getElementById("livesearch").style.border="1px solid #A5ACB2";
			$("#searchresult").html(response); 
		//	$("#finalResult").style.border = "1px solid #a5acb2";
		}, 
		error: function(){      
		    alert('Error while request..');
		}
	    });
	}
	return  false;
    });
});
	

/*
function showResult(str) {
  if (str.length==0) { 
    document.getElementById("livesearch").innerHTML="";
    document.getElementById("livesearch").style.border="0px";
    return;
  }
  if (window.XMLHttpRequest) {
    // code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp=new XMLHttpRequest();
  } else {  // code for IE6, IE5
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
  xmlhttp.onreadystatechange=function() {
    if (this.readyState==4 && this.status==200) {
      document.getElementById("livesearch").innerHTML=this.responseText;
      document.getElementById("livesearch").style.border="1px solid #A5ACB2";
    }
  }
  xmlhttp.open("GET","livesearchaction.php?q="+str,true);
  xmlhttp.send();
}
*/
