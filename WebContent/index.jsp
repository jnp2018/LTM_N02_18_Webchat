<!--  
	/*
 * Actor Ngô Thị Thúy Linh
 * git@github.com:jnp2018/exam-ltm_nhom02_chatbox.git
 * 
 * 
 * */

-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Web chat</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" type="text/css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="cus.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
	<style type="text/css">
		.ad{
			background: #ccc;
		}
		.cus{
			background: #77d9d3;
		}
		#chat{
			width: 800px;
			border: 1px solid #02d163;
    		padding: 20px
		}
	</style>

</head>
<body>

	<div>
  <!-- Styled -->
  
	<form>
		<h2>Login</h2>
		<input id="username" type="text" name="username" placeholder="Username">
		<br/>
		<input id="password" type="password" name="password" placeholder="Password">
		<br/>
		<span id="error" style="color : red;"></span>
		<br/>
		<input type="button" name="login" value="Login" id="login">
	</form>
	
	<div class="container" id="formchat">
		<h3 class=" text-center">Messaging</h3>
		<div class="messaging">
	      <div class="inbox_msg">
	        <div class="mesgs">
	          <div class="msg_history">
	           	<div class="incoming_msg" id="key">
	              <div class="received_msg">
	                <div class="received_withd_msg">
	                  <p>...</p>
	                  <span class="time_date"></span></div>
	              </div>
	            </div>
	          </div>
	          <div class="type_msg">
	            <div class="input_msg_write">
	              <input type="text" class="write_msg" placeholder="Type a message" />
	              <button class="msg_send_btn" type="button"><i class="fa fa-paper-plane-o" aria-hidden="true"></i></button>
	              <div class="upload-btn-wrapper">
					  <button class="btn">Upload a file</button>
					  <input type="file" name="myfile" id="file"/>
					</div>
	            </div>
	            
		      </div>
	      
	      
	      <p class="text-center top_spac"> Design by <a target="_blank" href="#">Ngô Thúy Linh</a></p>
	      
	    </div>
	</div>

		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script type="text/javascript">
			$(document).ready(function () {
				$("#key").hide();
				$('#formchat').hide();
				$('#chat').hide();
				var currentUser;
				var to;
				var websocket = new WebSocket("ws://172.20.10.14:8080/Webchat/chatRoomServer/cus");
				websocket.onopen = function(message) {
					
				};
				websocket.onmessage = function(message) {
				    var res = message.data.split("=");
				    if(res[0] === 'FILE_UPLOAD'){
				    	/* Hiển thị file */
				    	var filename = res[1];
				    	var namefile=filename.split(".");
				    	if(namefile[1].toLowerCase()==='jpg' || namefile[1].toLowerCase()==='png' || namefile[1].toLowerCase()==='gif')
				    		$('.msg_history').append('<div class="outgoing_msg"><div class="sent_msg"><img src="image?image='+filename+'"></div></div>')
			    		else
			    			$('.msg_history').append('<div class="outgoing_msg"><div class="sent_msg"><a href="file?file='+filename+'">'+filename+'</a></div></div>')
				    }
					if(res[0] === 'LOGIN'){
						if(res[1] === 'false'){
							$('#error').text('Tài khoản không tồn tại!!');
						}else{
							/* lưu lịch sử chat của khách hàng */
							if(localStorage.getItem("time_"+res[1])!==null){
					    		var timenow=localStorage.getItem("time_"+res[1])
					    		console.log(new Date(timenow).getTime())
					    		var t=new Date().getTime()
					    		console.log("time=" +(t-new Date(timenow).getTime()))
					    		if((t-new Date(timenow).getTime())/60000>10){
					    			localStorage.clear();
					    		}
					    	}
							if(localStorage.getItem(res[1]) === null){ 
						    	localStorage.setItem(res[1], JSON.stringify([]));
						    	
						    		
						    	
						     }else{
						    	console.log('s')
						    	console.log(JSON.parse(localStorage.getItem(res[1])))
						    	var a=JSON.parse(localStorage.getItem(res[1]));
						    	console.log(a.length)
						    	if(a.length !==0 ){
							    	from=JSON.parse(a[0]).form
							    	a.forEach(function(item){
							    		var it=JSON.parse(item)
										if(it.form !== from){
											$('.msg_history').append('<div class="incoming_msg"><div class="received_msg"><div class="received_withd_msg"><p>'+it.text+'</p><span class="time_date">'+new Date(it.datetime)+' </span></div></div></div>')
										}else{
											$('.msg_history').append('<div class="outgoing_msg"><div class="sent_msg"><p>'+it.text+'</p><span class="time_date">'+new Date(it.datetime)+'</span> </div></div>')
										}
							    		
							    	})
						    	}
						    } 
							$('#chat').show();
							$('#formchat').show();
							$('form').hide();
							currentUser = res[1];
						}
						
					}else if(res[0] === 'MESSAGE'){
						$('#key').hide();
						/*  Nhận tin  nhắn*/
						if($('#message').children().length == 0){
							var mes=JSON.parse(res[1])
							
							
						}
						/* lưu vào dạng giống cokkie */
						localStorage.setItem("time_"+currentUser,new Date())
						var arr = JSON.parse(localStorage.getItem(currentUser));
						
						
						arr.push(res[1]);
						localStorage.setItem(currentUser, JSON.stringify(arr));
						var mess=JSON.parse(res[1])
						var name = res[1].split(":");
						
						$('.msg_history').append(
				            '<div class="incoming_msg">'+
				              '<div class="received_msg">'+
				                '<div class="received_withd_msg">'+
				                  '<p>'+mess.message+'</p>'+
				                  '<span class="time_date">'+new Date(mess.datetime)+'</span></div>'+
				              '</div>'+
				            '</div>')
					}else if(res[0] === 'CLICKED'){
						to = res[1];
					}else if(res[0] === 'KEY'){
						$("#key").css({
						    'position': 'absolute',
						    'top': '90%',
						    'width': '79px'
						})
						$("#key").show();
					}
					
				};
				websocket.onclose = function(message) {};
				websocket.onerror = function(message) {};
				function sendMessage(message) {
					if (typeof websocket != 'undefined' && websocket.readyState == WebSocket.OPEN) {
						websocket.send(message);
					}
				}
				/*Login */
				$("#login").click(function(){
					var username= $("#username").val();
					var password= $("#password").val();
					sendMessage(JSON.stringify({
						username : username,
						password : password,
						action : 'LOGIN'
					}))
				});
				
				/* Send message */
				$(document).on("click",".msg_send_btn",function(){
					var txt=$('.write_msg').val();
					var arr = JSON.parse(localStorage.getItem(currentUser));
					console.log(to)
					arr.push(JSON.stringify({
						form:currentUser,
						to : to,
						text : txt,
						datetime: new Date().getTime()
					}));
					localStorage.setItem(currentUser, JSON.stringify(arr));
					$('.msg_history').append('<div class="outgoing_msg">'+
		              '<div class="sent_msg">'+
		                '<p>'+txt+'</p>'+
		                '<span class="time_date">'+new Date()+'</span> </div>'+
		            '</div>');
					sendMessage(JSON.stringify({
						from : currentUser,
						to : to,
						text : txt,
						action : 'MESSAGE'
					})) 
				})
				
				$(document).on("keydown", ".write_msg" ,function(){
					sendMessage(JSON.stringify({
						from : currentUser,
						to : to,
						action : 'KEY'
					}))
					
				})
				
	            /* Chọn file gửi lên */
				$(document).on('change','.upload-btn-wrapper input',function(){
					var file = document.getElementById('file').files[0]
					if(file.size<=100000){
						console.log(file)
						websocket.binaryType = "arraybuffer";
						websocket.send(JSON.stringify({
							from : currentUser,
							filename : file.name,
							action : 'UPLOAD_FILE',
							to : to
						}));
					    var reader = new FileReader();
					    var rawData = new ArrayBuffer();           
					    console.log(file.name);
					    reader.loadend = function() {
					    }
					    reader.onload = function(e) {
					        rawData = e.target.result;
					        console.log(rawData)
					        websocket.send(rawData);
					        console.log("the File has been transferred.")
					        //ws.send('end');
					    }
					    reader.readAsArrayBuffer(file);
					}else{
						alert("File quá lớn")
					}
					
					
					
				})
			})
			

		</script>
</body>
</html>