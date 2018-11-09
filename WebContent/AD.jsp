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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" type="text/css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="chat.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
	
	<style type="text/css">
		.ad{
			background: #ccc;
		}
		.cus{
			background: #77d9d3;
		}
		.chat1{
			width: 800px;
			border: 1px solid #02d163;
    		padding: 20px;
		}
		
	</style>

	
</head>
<body>
	<div class="container" id="formchat">
	
		<h2>Hệ thống</h2>
		<h3 class=" text-center">Messaging</h3>
		<div class="thongbao"></div>
		<div class="messaging">
	      <div class="inbox_msg">
	        <div class="inbox_people">
	          <div class="headind_srch">
	            <div class="recent_heading">
	              <h4>Recent</h4>
	            </div>
	            
	          </div>
	          <div class="inbox_chat">
	            
	            
	            
	          </div>
	        </div>
	      </div>
	      <p class="text-center top_spac"> Design by <a target="_blank" href="#">Ngô Thúy Linh</a></p>
	    </div>
	</div>
	
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
		</br>
		
		
	</div>
	
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script type="text/javascript">
			$(document).ready(function () {
				 
				$('#formchat').hide();
				$('#home').hide();
				var currentUser;
				var to = 'xxx';
				var text;
				var websocket = new WebSocket("ws://localhost:8080/Webchat/chatRoomServer/ad");
				websocket.onopen = function(message) {
					
				};
				
				websocket.onmessage = function(message) {
					console.log(message)
				    var res = message.data.split("=");
					if(res[0] === 'FILE_UPLOAD'){
						/* Hiện file người dùng gửi lên */
				    	var filename = res[1];
				    	var namefile=filename.split(".");
				    	if(namefile[1].toLowerCase()==='jpg' || namefile[1].toLowerCase()==='png' || namefile[1].toLowerCase()==='gif')
				    		$('.msg_history').append('<div class="outgoing_msg"><img src="image?image='+filename+'"></div>')
			    		else
			    			$('.msg_history').append('<div class="outgoing_msg"><a href="file?file='+filename+'">'+filename+'</a></div>')
				    }
					if(res[0]=== 'LIST'){
						/* Lịch sử các cuộc chat */
						var list = JSON.parse(res[1]);
						$('.inbox_msg').append('<div class="mesgs" id="a"><div class="msg_history"></div></div>')
					
						if(list !== null){
							list.forEach(function(it){
								console.log(it.from +'--'+currentUser)
								if(it.form === currentUser){
									$('#a .msg_history').append('<div class="incoming_msg"><div class="received_msg"><div class="received_withd_msg"><p>'+it.form+' : '+it.message+'</p><span class="time_date">'+it.datetime+' </span></div></div></div>')
								}else{
									$('#a .msg_history').append('<div class="outgoing_msg"><div class="sent_msg"><p>'+it.form+' : '+it.message+'</p><span class="time_date">'+it.datetime+'</span> </div></div>')
								}
								
							})
						}
						
					}
					if(res[0] === 'LOGIN'){
						if(res[1] === 'false'){
							$('#error').text('Tài khoản không tồn tại!!');
						}else{
							$('#formchat').show();
							$('form').hide();
							currentUser = res[1];
							if(localStorage.getItem(res[1]) === null){ 
						    	localStorage.setItem(res[1], JSON.stringify([]));
						     }else{
						    	console.log('s')
						    	var arr = JSON.parse(localStorage.getItem(res[1]))
						    	arr.forEach(function(it){
						    		var sp = it.split('_');
						    		$('.inbox_chat').prepend('<div file_name="'+it.substring(1,it.length-1)+'" class="chat_list" id="img'+sp[0].trim().substring(1,sp[0].length)+'">'+
						              '<div class="chat_people" >'+
						                '<div class="chat_img"> <img src="https://ptetutorials.com/images/user-profile.png" alt="sunil"> </div>'+
						                '<div class="chat_ib">'+
						                  '<h5>'+sp[0].trim().substring(1,sp[0].length)+'<span class="chat_date">Dec 25</span></h5>'+
						                  '<p>Test, which is a new approach to have all solutions astrology under one roof.</p>'+
						                '</div>'+
						              '</div>'+
						            '</div>');
						    	})	
						    }
							
						}
						
					}else if(res[0] === 'MESSAGE'){
						/* Hiện tin nhắn */
						$('#formchat .thongbao input').remove();
						var name = res[1].split(":");
						to = name[0].trim();
						var mes=JSON.parse(res[1])
						console.log(mes)
						
						$("#key"+mes.form).hide();
						$("#"+mes.form+" .msg_history").append('<div class="incoming_msg">'+
					              '<div class="received_msg">'+
					                '<div class="received_withd_msg">'+
					                  '<p>'+mes.message+'</p>'+
					                  '<span class="time_date"> '+new Date(mes.datetime)+'</span></div>'+
					              '</div>'+
					            '</div>');
						
						
					}else if(res[0] === 'CLICKED'){
						/* Sự kiện click vào thông báo hiện thị ra form chat */
						$('#formchat .thongbao input').remove();
						if(res[1]==="true"){
							$(".active_chat").removeClass("active_chat");
							$(".mesgs").hide();
							if($("#img"+to.trim()).length===0){
								$('.inbox_chat').prepend('<div class="chat_list active_chat" id="img'+to.trim()+'">'+
							              '<div class="chat_people" >'+
							                '<div class="chat_img"> <img src="https://ptetutorials.com/images/user-profile.png" alt="sunil"> </div>'+
							                '<div class="chat_ib">'+
							                  '<h5>'+to.trim()+'<span class="chat_date">Dec 25</span></h5>'+
							                  '<p>Test, which is a new approach to have all solutions astrology under one roof.</p>'+
							                '</div>'+
							              '</div>'+
							            '</div>');
								$('.inbox_msg').append('<div class="mesgs" id="'+to.trim()+'">'+
								          '<div class="msg_history">'+
								            '<div class="incoming_msg">'+
								              '<div class="received_msg">'+
								                '<div class="received_withd_msg">'+
								                  '<p>'+text+'</p>'+
								                  '<span class="time_date"> </span></div>'+
								              '</div>'+
								            '</div>'+
								            '<div class="incoming_msg" id="key'+to.trim()+'">'+
								              '<div class="received_msg">'+
								                '<div class="received_withd_msg">'+
								                  '<p>...</p>'+
								                  '<span class="time_date"></span></div>'+
								              '</div>'+
								            '</div>'+
								          '</div>'+
								          '<div class="type_msg">'+
								            '<div class="input_msg_write">'+
								              '<input type="text" class="write_msg" placeholder="Type a message" />'+
								              '<button class="msg_send_btn" type="button"><i class="fa fa-paper-plane-o" aria-hidden="true"></i></button>'+
								            '</div>'+
								          '</div>'+
								        '</div>'+
								      '</div>')
								      
							$("#key"+to.trim()).hide();
							}else{
								$("#"+to.trim()+" .msg_history").append('<div class="incoming_msg">'+
					              '<div class="received_msg">'+
					                '<div class="received_withd_msg">'+
					                  '<p>'+text+'</p>'+
					                  '<span class="time_date"> '+new Date()+'</span></div>'+
					              '</div>'+
					            '</div>');
							}
							
							
							
							$('#'+to.trim()).show();
							$('#formchat .thongbao input').remove();
							
							
						}else{
							$('#'+to.trim()).children().remove();
							console.log('input[userId='+res[1].trim()+']')
							$('.thongbao input[userId='+res[1].trim()+']').remove();
							$('#formchat .thongbao input').remove();
						}
					}else if(res[0] === 'PP'){
						/* Thông báo hiển thị nút*/
						var name = res[1].split(":");
						var tmp = to.trim();
						text = res[1];
						
						to = name[0];
						$('input[id='+tmp+']').attr('id',to.trim());
						/* var mes=JSON.parse(res[1])
						var tmp = to.trim();
						console.log(tmp)
						text=res[1];
						$('input[id='+tmp+']').attr('id',mes.form); */
						$('#formchat .thongbao').append(' <input style="color:red;" type="button" value="A message new" userId='+to.trim()+'>');
						
						
						
					}else if(res[0] === 'KEY'){
						/* Sự kiện typing */
						console.log(res[1])
						 $("#key"+res[1].trim()).css({
						    'position': 'absolute',
						    'top': '83%',
						    'width': '79px'
						})
						$("#key"+res[1].trim()).show();
					}else if(res[0] === 'LIST'){
						
					}
					
				};
				/* CLick vào lịch sử chat */
				$(document).on("click",".chat_list",function(){
					var t=$(this).attr("id")
					t=t.substring(3, t.lenght)
					console.log(t)
					$(".mesgs").hide();
					$('.active_chat').removeClass('active_chat')
					
					$("#"+t.trim()).show();
					$(this).addClass('active_chat')
					sendMessage(JSON.stringify({
						filename : $(this).attr('file_name'),
						action : 'FILE'
					}))
				})
				/* Click thông báo message mới */
				$(document).on("click","#formchat .thongbao input",function(){
					sendMessage(JSON.stringify({
						userclick : currentUser,
						to : to,
						action : 'CLICKED'
					}));
					var arr = JSON.parse(localStorage.getItem(currentUser));
					
					arr.push(JSON.stringify(to.trim()+"_"+currentUser.trim()));
					localStorage.setItem(currentUser, JSON.stringify(arr));
					
				});
				websocket.onclose = function(message) {};
				websocket.onerror = function(message) {};
				function sendMessage(message) {
					if (typeof websocket != 'undefined' && websocket.readyState == WebSocket.OPEN) {
						websocket.send(message);
					}
				}
				/*  Login*/
				$("#login").click(function(){
					var username= $("#username").val();
					var password= $("#password").val();
					sendMessage(JSON.stringify({
						username : username,
						password : password,
						action : 'LOGIN',
					}))
				});
				/* Send message */
				$(document).on("click",".msg_send_btn",function(){
					var txt=$('.write_msg').val();
					$('#'+$(this).parents(".mesgs").attr("id")+' .msg_history').append('<div class="outgoing_msg">'+
		              '<div class="sent_msg">'+
		                '<p>'+txt+'</p>'+
		                '<span class="time_date">'+new Date()+'</span> </div>'+
		            '</div>');
					sendMessage(JSON.stringify({
						from : currentUser,
						to : $(this).parents(".mesgs").attr("id"),
						text : txt,
						action : 'MESSAGE'
					})) 
				})
				/*  Sự kiện typing*/				
				$(document).on("keydown", ".write_msg" ,function(){
					sendMessage(JSON.stringify({
						from : currentUser,
						to : $(this).parents(".mesgs").attr("id"),
						action : 'KEY'
					}))
					
				})
				
			})
			

		</script>

</body>
</html>
