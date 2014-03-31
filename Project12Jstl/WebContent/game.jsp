<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "com.diycomputerscience.minesweeper.Board" %>
<%@ page import = "com.diycomputerscience.minesweeper.Square" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/styles.css" type="text/css">
<script type="text/javascript" language="javascript"  src="js/jquery-1.4.2.min.js"></script>
           
<title>Minesweeper</title>
</head>
<body>

<c:set var="isGameOver" value="${gameOver}" scope ="request" />
<c:if test="${not empty isGameOver  && isGameOver eq true }" >
	<h3 class='gameOver'>Game Over !</h3>
	<a href="./MinesweeperServe"> New game</a>
</c:if>

<div id="contents">
	<h2>Minesweeper</h2>
		<div id="board" oncontextmenu="return false;" ondrag="return false;" ondragstart="return false;">
		<table class="ms-grid">
			<c:set var="mineBoard"  value="${board}">
			</c:set>
			
			<c:if test="${not empty mineBoard }" >
				<c:set var="squares" value="${mineBoard.getSquares()}"/>
	   		    <c:forEach items="${squares}" var="datas" varStatus="row">
	   		    	<tr>
						<c:forEach items="${datas}" var="data" varStatus="col">	
							<c:set var="square" value="${data}" /> 
							<c:set	var="style" value = ""/>
							<c:set var="sCount" value="&nbsp;"/>
							
							
							<c:choose>
								<c:when test="${square.state == 'MARKED'}">
									<c:set	var="style" value = "marked"/>
								</c:when>
									 
							<c:when  test="${square.mine eq false && square.state == 'UNCOVERED'}">
									<fmt:parseNumber var ="cnt" type="number" value="${square.count }" />
									<c:set var="sCount"  value= "${(square.count==0) ? '' : cnt }"/>
							</c:when> 
							<c:when test="${square.mine eq true && square.state == 'UNCOVERED'}">
									<c:set var="sCount" value="<img src=images/mine.jpg  alt=GO />"/>	
							</c:when>
							</c:choose>
							
							<c:set var="row1" value="${row.index}" />
							<c:set var="col1" value="${col.index}" />
							<c:set var="rowcold" value="${row.index}-${col.index}" />
							<td id='<c:out value="${rowcold}" />' class='<c:out value="square ${style}" />' > ${ sCount}</td>
							
						</c:forEach>
					</tr>
				</c:forEach>
			</c:if>			 
					
			
		
		</table>
	</div>
</div>

<c:set var="gameOver"  value="false" />
<c:if test="${not empty isGameOver && isGameOver eq true }" >
	<c:set var="gameOver"  value="true"  />
</c:if>

<script type="text/javascript">
	$('.square').bind('click', function(e) {

		if(!<c:out value="${gameOver}"/>) {
		 	var point = e.target.id.split("-");
			post_to_url("leftClick", point[0], point[1]);
			} else {
			return false;
			} 
});

$('.square').bind('contextmenu', function(e){
	if(!<c:out value="${gameOver}"/>) {
    	var point = e.target.id.split("-");
    	post_to_url("rightClick", point[0], point[1]);	
    } else {
    	return false;
    }    
});

function post_to_url(action, row, col) {
	path = "${pageContext.request.contextPath}/MinesweeperServe";
    method = "post";

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);
	
    var hiddenField = document.createElement("input");
	hiddenField.setAttribute("type", "hidden");
	hiddenField.setAttribute("name", "action");
	hiddenField.setAttribute("value", action);
	form.appendChild(hiddenField);

	hiddenField = document.createElement("input");
	hiddenField.setAttribute("type", "hidden");
	hiddenField.setAttribute("name", "row");
	hiddenField.setAttribute("value", row);
	form.appendChild(hiddenField);
	
	hiddenField = document.createElement("input");
	hiddenField.setAttribute("type", "hidden");
	hiddenField.setAttribute("name", "col");
	hiddenField.setAttribute("value", col);
	form.appendChild(hiddenField);
    
    document.body.appendChild(form);
    form.submit();
}

</script>
</body>
</html>