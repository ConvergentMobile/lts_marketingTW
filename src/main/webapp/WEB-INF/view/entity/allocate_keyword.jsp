<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script LANGUAGE="JavaScript">
	$(document).ready(function() {		
		$( "#errwin" ).dialog({
			title: 'Alerts & Notifications',
			width: 400,
			height: 200,		
			dialogClass: 'no-close',
			autoOpen: false, 
			buttons: {
			  OK: function() {
				$(this).dialog("close");
				location.reload();
			  }
		       },
		});		
	});

	function reserve() {
		//alert('here 1: ' + $('#searchKeywordString').val());	
		var kw = $('#searchKeywordString').val();
		if (kw.indexOf(" ") > 0) {
			alert("Keyword must be a single word without any spaces");
			return;
		}		
		
        $.ajax({
            type : 'POST',
            url : 'allocateKeyword',
           	    data: $("#thisForm_dialog").serialize(),
            success : function(result) {
           		//$('#office').html(result);
           		//alert(result);
    			//$('#errwin').html('<div align="center">' + result + '</div>');
    			//$( "#errwin" ).dialog('open'); 
            	popup(result, 1);
			},
			error : function(e) {
				alert('error: ' + e);
			}                        
        });
	}	
</script>

<script language="JavaScript">
	function validate(form) {
		if (! isZip(form['category_3.zip'].value)) {
			alert("Please enter a valid Zip");
			return false;
		}	
	
		if (form['category_3.email'].value == null 
				|| form['category_3.email'].value.length <= 0) {
			alert("Please enter a valid Email");
			return false;
		}	

		/*
		if (form['category_3.adminMobilePhone'].value == null 
				|| form['category_3.adminMobilePhone'].value.length <= 0) {
			alert("Please enter a valid Business Mobile Phone");
			return false;
		}	
		*/

		if (form['category_3.description'].value == null 
				|| form['category_3.description'].value.length <= 0) {
			alert("Please enter a valid Description");
			return false;
		}	
		
		return true;
	}
</script>
		

			<div id="content" class="inner">
			
			<form:form id="thisForm_dialog" method="post" action="" commandName="ltUser">

			<div class="my_popup_03 mpu_02" id="id_popup_01">
	<div class="mpu_wrapper">
  	<!-- title -->
    <div class="mpu_title">
    	<table cellpadding="0" cellspacing="0" border="0" width="100%">
      <tr>
      	<td style="text-align:center"><h3>Get Your Keyword</h3></td>
      	<td><button title="Close (Esc)" type="button" onclick="closeIt()" class="mfp-close">&times;</button></td>
      </tr>
      </table>
    </div>
    <!-- // title -->
			<table border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top">
					<table width="400" border="0" cellpadding="3" cellspacing="0">
						<tr>	
							<td valign="bottom"><font color="red">*</font></td>						
							<td colspan="2" valign="top">
								<strong><form:label path="searchOfficeIdString">
									<c:if test = "${ltUser.currentPage == 'Off'}">
										<spring:message code="label.officeId" />
										</td>
										<td><form:input path="searchOfficeIdString" size="15" /></td>										
									</c:if>
									<c:if test = "${ltUser.currentPage == 'Ent'}">
										<spring:message code="label.entityId" />
										</td>
										<td><form:input path="searchEntityIdString" size="10" /></td>										
									</c:if>									
								</form:label></strong>
							<td>&nbsp;</td>
						</tr>
					<%--
						<tr>
							<td><font color="red">*</font></td>						
							<td colspan="2" valign="top">
								<strong><form:label path="searchCityString"><spring:message code="label.adminMobilePhone" /></form:label></strong>
							</td>
							<td><form:input path="searchCityString" size="15" />									
							</td>
							<td>&nbsp;</td>
						</tr>	
					--%>						
						<tr>
							<td valign="bottom"><font color="red">*</font></td>	
							<td colspan="2" valign="top">
								<strong><form:label path="searchKeywordString"><spring:message code="label.keyword" /></form:label></strong>
							</td>
							<td><form:input path="searchKeywordString" maxlength="15" /></td>
							<td>&nbsp;</td>
						</tr>
			</table>
			
			<br />

					<div>
						<a href="#" onclick="reserve()" class="btn_dark_blue">Submit</a>
					</div>

</form:form>
<br/>
</div>
</div>

