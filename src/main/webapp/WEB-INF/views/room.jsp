<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>객실관리</title>
</head>
<style>	
	body{
		background-image:url("https://search.pstatic.net/sunny/?src=https%3A%2F%2Fe0.pxfuel.com%2Fwallpapers%2F852%2F973%2Fdesktop-wallpaper-the-sun-mountains-music-space-star-background-80s-neon-80-s-synth-retrowave-synthwave-new-retro-wave-futuresynth-sintav-retrouve-for-section-%25D1%2580%25D0%25B5%25D0%25BD%25D0%25B4%25D0%25B5%25D1%2580%25D0%25B8%25D0%25BD%25D0%25B3.jpg&type=sc960_832");
		background-repeat: no-repeat right;
	    background-size: cover;
	}
    input,select{
        font-size: 20px;
    }
    table{
        margin: auto;
        background-color:white;
    }
    .center{
        text-align: center;
    }
    .top{
        vertical-align: top;
    }
    .right{
        text-align: right;
    }
</style>
<body>
	<input type=hidden id=roomid  value="">
    <h1 class="center" style="color:red">객실관리</h1>
    <p style="text-align:center; color:gray; font-size:20px"><a href="/">예약관리 </a>객실관리</p>
    <table border="1" style="width: 45%;">
        <tr>
            <td style="width: 50%;">
                <select size="20" style="width: 100%;" id="room">
                    
                </select>
            </td>
            <td class="top">
                <table>
                    <tr>
                        <td class="right">객실종류</td>
                        <td>
                            <select id=roomtype>
                            <option value="다시">객실종류고르시오</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="right">객실명</td>
                        <td><input type="text" id="roomName"></td>
                    </tr>
                    <tr>
                        <td>숙박인원</td>
                        <td><input type="number" min="0" max="20" id="people">명</td>
                    </tr>
                    <tr>
                        <td>1박요금</td>
                        <td><input type="number" id="price">원</td>
                    </tr>
                     <tr>
                        <td colspan="2" class="center">
                            <input type="button" id="add" value="등록">
                            <input type="button" id="cancel" value="삭제">
                            <input type="button" id="clean" value="비우기">
                        </td>
                     </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
.ready(function(){
	getList();
	$.ajax({
		type:'post',
		url:'/select',
		data:{},
		dataType:'json',
		success:function(data){
			for(let i=0;i<data.length;i++){
				let ob=data[i];
				let str='<option value='+ob['id']+' >'+ob['typename']+'</option>';
				$('#roomtype').append(str);
			}
		}
	})
})

.on('click','#clean',function(){
	$('#roomName,#people,#price,#roomid').val('');
	$('#roomtype option:eq(0)').prop("selected",true);
})

.on('click','#room',function(){
	let select = $('#room option:selected').text();
	
	let inf=select.split(',');
	$('#roomid').val(inf[0])
	console.log($('#roomid').val())
	$('#roomName').val(inf[1]);
	$('#roomtype option').each(function(){
		if($(this).text()==inf[2]){
			$(this).prop('selected',true)
			return false;
		}
	})	
	$('#people').val(inf[3])
	$('#price').val(inf[4])
	
		
	
})

.on('click','#cancel',function(){
	if(confirm("정말로 지우시겠습니까?")){
		$.ajax({
			type:'get',
			url:'/remove',
			data:{id:$('#roomid').val()},
			dataType:'text',
			success:function(data){
				if(data=='1'){
					getList();
				} else {
					alert("remove 실패")
				}
				$('#roomName,#people,#price,#roomid').val('');
				$('#roomtype option:eq(0)').prop("selected",true);
			}
		})
	} else {
		return false;
	}
})

.on('click','#add',function(){
	if($('#roomtype option:selected').val()==null ||$('#roomtype option:selected').val()=="다시"){
		alert('객실을 고루시오')
		return false;
	}
	if($('#roomName').val()==null||$('#roomName').val()==""){
		alert('이름을 적으시오')
		return false;
	}
	if($('#people').val()==null||$('#people').val()==""){
		alert('인원수를 적으시오')
		return false;
	}
	if($('#price').val()==null||$('#price').val()==""){
		alert('요금을 적으시오')
		return false;
	}
	$.ajax({
		type:'post',
		url:'/add',
		data:{type:$('#roomtype option:selected').val(),name:$('#roomName').val(),personnel:$('#people').val(),price:$('#price').val(),id:$('#roomid').val()},
		dataType:'text',
		success:function(data){
			if(data=='1'){
				getList();
			} else {
				alert('등록실패')
			}
			$('#roomName,#people,#price,#roomid').val('');
			$('#roomtype option:eq(0)').prop("selected",true);
		}
		})
})
function getList(){
	$.ajax({
		type:'post',
		url:'/list',
		data:{},
		dataType:'json',
		success:function(data){
			$('#room').empty();
			for(let i=0;i<data.length;i++){
				let ob=data[i]
				let str='<option>'+ob['id']+","+ob['name']+","+ob['typename']+","+ob['personnel']+","+ob['price']+'</option>'
				$('#room').append(str)
			}
			
		}
	})
}




</script>
</html>