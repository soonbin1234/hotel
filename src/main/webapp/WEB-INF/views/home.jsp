<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약관리</title>
</head>
<style>	
	body{
		background-image:url("https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.pinimg.com%2F736x%2Ff5%2F88%2F09%2Ff58809f9602b6b1bdc4fb0926715f77f.jpg&type=sc960_832");
		
	}
	caption {
		color : blue;
	}
    input,select{
        font-size: 20px;
    }
    table{
        background-color: white;
        margin: auto;
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
<input type=hidden id=hidden value="">
    <h1 class="center" >예약관리</h1>
    <p style="text-align:center;  color:#d1df4c; font-size:20px">예약관리 <a href="/room">객실관리</a></p>
    <table border="1" style="width: 90%; height: 700px;" >
        <tr>
            <td style="width: 33%; background-color: beige;" class="top">
                <table>
                	<caption><h3>예약하기</h3></caption> 
                    <tr>
                        <td>숙박기간</td>
                        <td><input type="date" id=start>~<input type="date" id=end></td>
                    </tr>
                    <tr>
                        <td>예정인원</td>
                        <td><input type="number" max="20" min="0" id="personnel">명</td>
                        <td style="text-align: right;"><input type="button" value="&#128269;" id="btnfind"></td>
                    </tr>
                     <tr>
                        <td colspan="3">
                            <select size="16" style="width: 100%;" id=room>
                            </select>
                        </td>
                     </tr>
                </table>
            </td>
            <td class="top" style="background-color: gray;">
                <table>
                    <caption><h3>예약상세</h3></caption>
                    <tr>
                        <td class="right">숙박기간</td>
                        <td><input type="date" id=start2 readonly>~<input type="date" id=end2 readonly></td>
                    </tr>
                    <tr>
                    	<td class="right">객실번호</td>
                    	<td><input type=number id=id readonly></td>
                    </tr>
                    <tr>
                        <td class="right">객실종류</td>
                        <td>
                            <input type=text id=roomtype readonly>
                        </td>
                    </tr>
                    <tr>
                        <td class="right">객실명</td>
                        <td><input type="text" id=roomname readonly></td>
                    </tr>
                    <tr>
                        <td class="right">예정인원</td>
                        <td><input type="number" max="20" min="0" id=people>명</td>
                    </tr>
                    <tr>
                        <td class="right">대표자명</td>
                        <td><input type="text" id=name></td>
                    </tr>
                    <tr>
                        <td class="right">모바일번호</td>
                        <td><input type="number" id=mobile></td>
                    </tr>
                    <tr>
                        <td class="right">숙박비</td>
                        <td><input type="number" id=price readonly>원</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="center">
                            <input type="button" value="등록" id=btnGo>
                            <input type="button" value="삭제" id=btnRemove>
                            <input type="button" value="비우기" id=btnClear>
                        </td>
                    </tr>
                </table>
            </td>
            <td class="top" style="background-color: orange;">
            <table>
            	<caption><h3>예약내역</h3></caption>
            	<tr>
                <td>
                <select size="16" style="width: 100%;" id=yeyak>
                </select>
                </td>
           		</tr>
            </table>
            </td>
        </tr>
    </table>
</html>
<script src="https://code.jquery.com/jquery-latest.js"></script>
<script>
$(document)
.ready(function(){
	getYeyakList()
})

.on('click','#room',function(){
	let select = $('#room option:selected').text()
	let inf=select.split(',');
	$('#id').val(inf[0])
	$('#roomtype').val(inf[2])
	$('#roomname').val(inf[1])
	$('#start2').val($('#start').val())
	$('#end2').val($('#end').val())
	$('#people').val($('#personnel').val())
	$.ajax({
		type:'post',
		url:'getDate',
		data:{start:$('#start').val(),end:$('#end').val()},
		dataType:'text',
		success:function(data){
			let price=data*inf[4]
			$('#price').val(price)
		}
	})
})

.on('click','#yeyak',function(){
	let select =$('#yeyak option:selected').text()
	let inf=select.split(',')
	$('#start2').val(inf[1])
	$('#end2').val(inf[2])
	$('#id').val(inf[0])
	$('#roomname').val(inf[3])
	$('#people').val(inf[4])
	$('#price').val(inf[5])
	$('#name').val(inf[6])
	$('#mobile').val(inf[7])
	$('#hidden').val($('#yeyak option:selected').val())
	$.ajax({
		type:'post',
		url:'/getType',
		data:{id:inf[0]},
		dataType:'text',
		success:function(data){			
			$('#roomtype').val(data)
		}
	})
})

.on('click','#btnGo',function(){
	if($('#name').val()==null || $('#name').val()==""){
		alert('대표자명을 적으시오')
		return false
	}
	if($('#mobile').val()==null || $('#mobile').val()==""){
		alert('모바일 번호를 적으시오')
		return false
	}
	$.ajax({
		type:'post',
		url:'/yeyak',
		data:{start:$('#start2').val(),end:$('#end2').val(),id:$('#id').val(),people:$('#people').val(),name:$('#name').val(),mobile:$('#mobile').val(),price:$('#price').val(),hidden:$('#hidden').val()},
		datType:'text',
		success:function(data){
			if(data=='1'){
				getYeyakList()
			} else{
				alert('예약실패')
			}
			$('#start,#end,#personnel,#start2,#end2,#id,#roomtype,#roomname,#people,#name,#mobile,#price,#hidden').val('')
			$('#room').empty()
		}
	})
})

.on('click','#btnRemove',function(){
	if($('#hidden').val()==null||$('#hidden').val()==""){
		alert('정보가없습니다')
		return false
	}
	
	if(confirm("정말로 지우시겠습니까?")){
		$.ajax({
			type:'get',
			url:'/yeyakRemove',
			data:{id:$('#yeyak option:selected').val()},
			dataType:'text',
			success:function(data){
				if(data=='1'){
					getYeyakList();
				} else {
					alert("remove 실패")
				}
				$('#start,#end,#personnel,#start2,#end2,#id,#roomtype,#roomname,#people,#name,#mobile,#price,#hidden').val('')
			}
		})
	} else {
		return false;
	}
})

.on('click','#btnClear',function(){
	$('#start,#end,#personnel,#start2,#end2,#id,#roomtype,#roomname,#people,#name,#mobile,#price,#hidden').val('')
	$('#room').empty()
})
.on('click','#btnfind',function(){
	if($('#start').val()==null || $('#start').val()==""){
		alert('체크인날짜를 고르세요')
		return false
	}
	if($('#end').val()==null || $('#end').val()==""){
		alert('체크아웃날짜를 고르세요')
		return false
	}
	if($('#personnel').val()==null || $('#personnel').val()==""){
		alert('인원수를 적으시오')
		return false
	}
	
	$.ajax({
		type:'post',
		url:'/find',
		data:{personnel:$('#personnel').val(),start:$('#start').val(),end:$('#end').val()},
		dataType:'json',
		success:function(data){
			$('#room').empty()
			for(let i=0;i<data.length;i++){
				let ob=data[i]
				let str='<option>'+ob['id']+","+ob['name']+","+ob['typename']+","+ob['personnel']+","+ob['price']+'</option>'
				$('#room').append(str)
			}
		}
	})
})

function getYeyakList(){
		$.ajax({
			type:'post',
			url:'/yeyaklist',
			data:{},
			dataType:'json',
			success:function(data){
				$('#yeyak').empty();
				for(let i=0;i<data.length;i++){
					let ob=data[i]
					let str='<option value='+ob['id']+'>'+ob['room_id']+","+ob['start']+","+ob['end']+","+ob['roomname']+","+ob['people']+","+ob['price']+","+ob['name']+","+ob['mobile']+'</option>'
					$('#yeyak').append(str)
				}
			}
		})
} 


</script>