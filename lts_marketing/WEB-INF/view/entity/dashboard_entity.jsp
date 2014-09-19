<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
.ui-dialog .ui-dialog-title {
  text-align: center;
  width: 100%;
}
</style>

        <script src="http://ajax.googleapis.com/ajax/libs/swfobject/2.1/swfobject.js"></script>

<script type="text/JavaScript">	
	$(document).ready(function() {
		resetForm();
	});

	function resetForm() {
		$('#thisForm')[0].reset();			
		//$('input[type="radio"]').prop('checked', false);
		//$('input:checkbox').removeAttr('checked');
				
	}
	
	function createHotspot() {
		if (${sites == null}) {
		 	$('#errwin').html("Please allocate a keyword for each of your offices");
			$('#errwin').dialog();	
			return false;
		}
		
		userId = $('#uid').val();
		if (${userId == ''}) 
			window.open('createHotspot',"mywindow","scrollbars=yes,menubar=1,resizable=1,width=450,height=550");		
		else {
			alert('userId: ' + userId);
			window.open('createHotspot?userId=' + userId,"mywindow","scrollbars=yes,menubar=1,resizable=1,width=450,height=550");		
		}
	}
	
	function createHotspot1(userId) {
		$.ajax({
			type : 'GET',
			url : 'createHotspot',
			data : $('#thisForm').serialize(),
			success : function(result) {
				$('#dialog1').html(result);
				$('#dialog1').dialog({
					title : 'Create Decal',
					height : 500,
					width : 400,
					buttons : {
						"Close" : function() {
							$(this).dialog("close");
							location.reload();
						}
					},
				});

			},
			error : function(e) {
				alert('error: ' + e.text());
			}
		});
	}
	
	function showSelectedMsg(msgType) {
		if (msgType == "Corp") {		
			val = document.getElementById("sendSearchStateString").value;
			var msgText = $('#sendSearchStateString option:selected').text();
			alert('val, msgText: ' + val + ', ' + msgText);
		}
		if (msgType == "Cust") {		
			val = document.getElementById("sendSearchDMAString").value;
			var msgText = $('#sendSearchDMAString option:selected').text();
			alert('val, msgText: ' + val + ', ' + msgText);
		}	
					
		$('#sendSearchCityString').val(msgText);
	}
	
	function getProfile1(userId) {
		$('#userId').val(userId);
	        $.ajax({
	            type : 'GET',
	            url : 'getProfile',
	            data: 'userId=' + userId,
	            success : function(result) {
            		$('#office').html(result);
				},
				error : function(e) {
					alert('error: ' + e.text());
				}                        
	        });
	}

	function getProfile(userId) {
		var outstr = '';
		var outstr2 = '';
		
		$('#uid').val(userId);

		$.ajax({
			type : 'GET',
			contentType : "application/html",
			url : 'getProfileInfo',
			data : 'userId=' + userId,
			success : function(category) {			
				if (!category) {
					alert("No Business Information found");
					outstr += '<c:set var="userId" value="' + userId + '"/>';
					$('#biz_info').html(outstr);
 					$('#biz_info_2').html(outstr2);
                 			
					return;
				}
				outstr += category.businessName + '<br/>';
				if (category.website != null) {
					outstr += category.website + '<br/>';
				}
				outstr += category.address + '<br/>';
				outstr += category.city + ',' + category.state + '&nbsp;'
						+ category.zip + '<br/>';
				outstr += category.phone;
				outstr += '<c:set var="userId" value="' + userId + '"/>';
				
				outstr2 = '<td class="td_02"><a href="#" onclick="getProfile1('
						+ userId + ')">Expand</a></td>';
				//alert(outstr);
				$('#biz_info').html(outstr);
				$('#biz_info_2').html(outstr2);

			},
			error : function(e) {
				alert('error: ' + e.text());
			}
		});		
	}

	function saveProfile() {
		$.ajax({
			type : 'POST',
			url : 'saveProfile',
			data : $("#thisForm").serialize(),
			success : function(result) {
				$('#content').html(result);
			},
			error : function(e) {
				alert('error: ' + e.text());
			}
		});
	}

	function setMsgType(msgType) {
		if (msgType == 'Custom') {
			$('#msgsCust').show();
			$('#msgsCorp').hide();
		}
		if (msgType == 'Corporate') {
			$('#msgsCorp').show();
			$('#msgsCust').hide();
		}

	}

	function setKeyword(userId, entId, offId, status) {
		if (status == 'R') {
			var val = offId;
			var off = 'true';
			if (offId == '') {
				val = entId;
				off = 'false';
			}
			allocateKeyword(val, off);
			//return;
			//window.open('allocateKeyword?entOffId=' + val + '&off=' + off,"mywindow","scrollbars=yes,menubar=1,resizable=1,width=450,height=550");		

		}
		//getProfile(userId);
	}

	function allocateKeyword(entOffId, off, userId) {
		$.ajax({
			type : 'GET',
			url : 'allocateKeyword',
			data : 'entOffId=' + entOffId + '&off=' + off,
			success : function(result) {
				//$('#id_content').html(result);

				$('#dialog1').html(result);
				$('#dialog1').dialog({
					title : 'Keyword Allocation',
					height : 500,
					width : 400,
					buttons : {
						"Close" : function() {
							$(this).dialog("close");
							location.reload();
						}
					},
				});

			},
			error : function(e) {
				alert('error: ' + e.text());
			}
		});
	}
	
	function changeKeyword(keyword, status) {
		if (status == 'R') {
			alert("Must allocate your keyword first");
			return;
		}
	        $.ajax({
	            type : 'GET',
	            url : 'changeKeyword',
            	    data: 'keyword=' + keyword,
	            success : function(result) {
			$('#dialog1').html(result);
			$('#dialog1').dialog({
 				dialogClass: "no-close",			
				title: 'Change Keyword',
				modal: false,
				width:600,	
                position: {
                    my: "center",
                    at: "center",
                    of: "#id_content_02"
                },	       
			    	buttons: {
					"Close": function () {
				    		$(this).dialog("close");
				    		location.reload();				    		
					}
			    	},								
			});            	    
            	    },
				error : function(e) {
					alert('error: ' + e);
				}                        
	        });	
	}
	
	function submitMsg() {
		if (${sites == null}) {
		 	$('#errwin').html("Please allocate a keyword for each of your offices");
			$('#errwin').dialog();	
			return false;
		}
		
		$('thisForm').attr('novalidate','novalidate');
		
		var msg = $('#sendSearchCityString').val();

		if (msg == "") {
			alert("Must specify message text");
			return false;
		}
		
		$.ajax({
		    type : 'POST',
		    url : 'createCustomMessage',
		    data: $("#thisForm").serialize(),
		    success : function(result) {
				alert(result);
				$('#sendSearchCityString').val('');
				location.reload(); //to update the pending msg list				
			},
				error : function(e) {
					alert('error: ' + e.text());
			}                        
		});
				
	}	
	
	function runSort(sortBy) {
		var form = document.getElementById("thisForm");

		var oldCol = $('#sortColumn').val();
		var oldOrd = $('#sortOrder').val();
		
		if (sortBy == oldCol) {		
			if (oldOrd == "asc") {
				$('#sortOrder').val('desc');
			} else {
				$('#sortOrder').val('asc')			}
		} else {
			$('#sortColumn').val(sortBy);
			$('#sortOrder').val('asc');
		}
		
		form.action = 'dashboardEntity';
		form.method = 'GET';
		form.submit();	
	}	
</script>

  <!-- // header -->
  <!-- content wrapper -->
  <div class="content_wrapper" id="content_wrapper">
   <form:form id="thisForm" method="post" action="" commandName="ltUser">

		<div id="dialog1" title="Alert" style="display:none">
		</div>
		
  	<!-- left side navigation -->
  	<ul class="ul_left_nav">
	<c:if test = '${ltUser.user.roleActions[0].roleType == "Entity"}'>  	
    		<li class="si_dashboard selected"><a href="dashboardEntity">Dashboard</a></li>
		<li class="si_custom_msg"><a href="customMessageEntity">Create Custom Message</a></li>
	      	<li class="si_confirmation"><a href="confirmationMessage">Confirmation Message</a></li>		
		<li class="si_send_msg"><a href="sendMessage">Send Message</a></li>
	</c:if>
	<c:if test = '${ltUser.user.roleActions[0].roleType == "Office"}'>
    		<li class="si_dashboard selected"><a href="dashboardOffice">Dashboard</a></li>	
		<li class="si_custom_msg"><a href="customMessage">Create Custom Message</a></li>
	      	<li class="si_confirmation"><a href="confirmationMessage">Confirmation Message</a></li>	
	</c:if>   
 	<c:if test = '${ltUser.user.roleActions[0].roleType == "Corporate"}'>
    		<li class="si_dashboard selected"><a href="dashboardCorp">Dashboard</a></li>	
      		<li class="si_custom_msg_approve"><a href="customMessageCorp">Approve Custom Messages</a></li>   
		<li class="si_send_msg"><a href="sendMessage">Send Message</a></li>
	</c:if> 
	<li class="si_reports"><a href="getReports">Reports</a></li>
      	<li class="si_mobile_profile"><a href="getProfile">My Mobile Profile</a></li>
      	<li class="si_toolbox"><a href="toolbox-office.html">Convergent Toolbox</a></li>
    </ul>
		<!-- // left side navigation -->
    <!-- content area -->
    <div class="content" id="id_content_02">
    	<div class="nav_pointer pos_01"></div>
      <!-- subheader -->
      <div class="subheader clearfix">
      	<h1>DASHBOARD</h1>
        <p>Entity Id: <c:out value="${ltUser.sites[0].customField1}"/></p>
      </div>

		<form:hidden path="sortColumn"/>
      	<form:hidden path="sortOrder"/>
      	<form:hidden path="userId"/>
      	<input type="hidden" id="uid" value=""/>
      	
      <!-- // subheader -->
    	<div class="inner_box">
      	<!-- box -->
        <div class="box box_blue_title box_keyword">
        	<!-- title -->
        	<div class="box_title">
          	<h2>List of Keywords</h2>
          </div>
          <!-- // title -->
          <table width="100%" class="grid grid_keyword">
          <colgroup>
          	<col width="6%"  />
            <col width="25%" />
            <col width="15%" />
            <col width="20%" />
 	    <col width="12%" />            
          </colgroup>
          <thead>
          	<tr>
              <th class="th_01"><div>#</div></th>
              <th class="th_02"><div><a href="javascript:runSort('keyword')">Keyword</a></div></th>
              <th class="th_02"><div><a href="javascript:runSort('customField1')">Entity Id</a></div></th>
              <th class="th_02"><div><a href="javascript:runSort('customField2')">Office Id</a></div></th>              
	      <th class="th_02"><div></div></th>            
            </tr>
          </thead>
          </table>
           <div id="id_entity_keywords">
            <table width="100%" class="grid grid_keyword">
            <colgroup>
              <col width="6%"  />
              <col width="25%" />
              <col width="15%" />
              <col width="20%" />
              <col width="12%" />              
            </colgroup>
             <tbody>           							
		<c:forEach var="site" items="${ltUser.sites}" varStatus="loopStatus"> 
			<c:set var="keyword" value="${site.keyword}" />
			<c:set var="status" value="${site.customField3}"/>	
			<c:choose>
			   <c:when test = "${site.customField3 == 'R'}">
				<tr class="${loopStatus.index % 2 == 0 ? 'slighty_red' : 'slighty_red'}">
			   </c:when>
			<c:otherwise>
				<tr class="${loopStatus.index % 2 == 0 ? 'even' : 'odd'}">
			</c:otherwise>
			</c:choose>				
				<td class="td_01"><div><c:out  value="${loopStatus.count}"/></div></td>																
			   <c:if test = "${site.customField3 == 'R'}">
				<td class="td_02"><div><a href="#" onclick="setKeyword('${site.userId}', '${site.customField1}', '${site.customField2}', '${site.customField3}')">
						<c:out  value="${site.keyword}"/></a></div></td>								
			   </c:if>
			   <c:if test = "${site.customField3 != 'R'}">
				<td class="td_02"><div><a href="#" onclick="getProfile('${site.userId}')">
						<c:out  value="${site.keyword}"/></a></div></td>								
			   </c:if>			   
				<td class="td_03"><div><c:out  value="${site.customField1}"/></div></td>
				<td class="td_03"><div><c:out  value="${site.customField2}"/></div></td>	
				<c:if test = "${site.customField3 != 'R'}">				
					<td class="td_04"><a href="#" onclick="changeKeyword('${site.keyword}', '${status}')" class="btn_select_01">Change</td>
				</c:if>								
			</tr>			   
		</c:forEach>	
            </tbody>
            </table>
          </div>
          <table width="100%" class="grid grid_keyword">
            <colgroup>
              <col width="6%"  />
              <col width="32%" />
              <col width="23%" />
              <col width="20%" />
            </colgroup>
            <tfoot>
              <tr>
                <td colspan="4"></td>
              </tr>
            </tfoot>
          </table>
        </div>
        <!-- // box -->
      	<!-- box -->
        <div class="box box_grey_title box_message">
        	<!-- title -->
        	<div class="box_title mb9">
          	<h2>Create Custom Message</h2>
          </div>
          <!-- // title -->
          <!-- wide_column -->
          <div class="wide_column_wrapper custom_msg_01" style="height:407px;">
          	<div class="description">  
               <p>
                All new messages will be reviewed for compliance with the corproate policies. Your message may be Accepted or Rejected. Accepted and Rejected messages will appear on the right hand-side panel. Messages are usually reviewd within 1 week after submission.
              </p>
              <p>
                Please type your Message in the space below.            
              </p>
            </div>
            <label for="msg_content" class="lb_01">Message Content:</label>
            <div class="big_input_wrapper med_input_wrapper">
            	<form:textarea path="sendSearchCityString" class="input_big" rows="4"/>
            </div>       
            <div class="button_wrapper_01 clearfix">
            	<input type="submit" onclick="return submitMsg()" class="btn_green btn_01" value="Create & Send for Approval">
            </div>
          </div>
          <!-- // wide_column -->
        </div>
      </div>
    </div>
    <!-- // content area -->
    
    <!-- sidebar -->
    <div class="sidebar" id="id_sidebar_02">
    	<div class="inner">
      	<!-- title -->
        <div class="sb_title sb_title_ico ico_sb_mobile">
        	<h2 class="Mobile Marketing">Mobile Marketing</h2>
        </div>
        <!-- // title -->
        <!-- sidebar box -->
        <div class="sb_box">
          <!-- information wrapper -->
          <div class="information_wrapper">
          	<div class="info_title">
            	<a href="#" class="prevnext info_prev" id="id_prev_info"></a>
              <a href="#" class="prevnext info_next get_next_info"></a>
              <h3>Information</h3>
            </div>
            <!-- slider -->
            <div class="infoslider" id="infoslider">
            	<!-- slide -->
              <div class="slide">
              	<p>
                	Now, you can instantly reach your customers with the latest deals, promos, discounts, and other general information about your business 
                  using the power of text messaging&hellip; <b>any time of the day</b>!
                </p>
                <p class="p_small">
                	Don't forget&hellip; it is important to <span class="sp_red">PROMOTE, PROMOTE, PROMOTE</span> your call to action. You can send the best offers to your subscribers, 
                  but customers will only know you are there if you promote.
                </p>
              </div>
              <!-- // slide -->
            	<!-- slide -->
              <div class="slide">
              	<p>
                	1 Now, you can instantly reach your customers with the latest deals, promos, discounts, and other general information about your business 
                  using the power of text messaging&hellip; <b>any time of the day</b>!
                </p>
              </div>
              <!-- // slide -->

            </div>
            <!-- // slider -->
            <div class="infonext_wrapper"><a href="#" class="lnk_infonext get_next_info">Next</a></div>
          </div>
          <!-- // information wrapper -->
          <!-- biz info wrapper -->
          <div class="biz_info_wrapper">
            <!-- title -->
            <div class="sb_title sb_title_ico ico_sb_biz">
              <h2 class="Mobile Marketing">Business Information</h2>
            </div>
            <!-- // title -->
            <div class="biz_info_grid_wrapper">
              <table class="grid bizinfo_grid" width="100%">
              <colgroup>
              <col width="79%" />
              <col width="21%" />
              </colgroup>
              <tbody>
                <tr>
                  <td class="td_01">
                  	<div  id="biz_info">
                  		<c:set var="userId" value="${ltUser.category.userId}"/>
				<c:out value="${ltUser.category.businessName}"/>
				<br/>
				<c:out value="${ltUser.category.website}"/>						
				<br/>
				<c:out value="${ltUser.category.address}"/>
				<br/>
				<c:out value="${ltUser.category.city}"/>, 
				<c:out value="${ltUser.category.state}"/> 
				&nbsp;<c:out value="${ltUser.category.zip}"/>
				<br/>
				<c:set var="phone" value="${ltUser.category.phone}"/>
				<c:out value="(${fn:substring(phone, 0, 3)}) ${fn:substring(phone, 3, 6)}-${fn:substring(phone, 6, fn:length(phone))}"/>				
				</div>
		  </td>
		  <td class="td_02" id="biz_info_2"><a href="#" onclick="getProfile1('${userId}')">Expand</a></td>				  
		</tr>
	      </tbody>
	      </table>
	    </div>
	  </div>				
          <!-- // biz info wrapper -->                  	
          <div class="hotspot_wrapper">
            <!-- title -->
            <div class="sb_title sb_title_ico ico_sb_hotspot">
              <h2 class="Mobile Marketing">Get your hotspot</h2>
            </div>
            <!-- // title -->
            <div class="hotspot">
            	<!-- box -->
          		<div class="hotspot_box">
              	<p class="p_left">Customize <br>your <br>Hotspot</p>
                <p class="p_right">Select <br>your <br>design</p>
                <div class="hotspot_seal"><img src="images/seal_hotspot_001.png" width="168" height="168"></div>
              </div>
              <!-- // box -->
              <ul class="ul_hotspot">
              	<li><img src="images/hotspot_thumb_001.png" width="44" height="44"></li>
                <li><img src="images/hotspot_thumb_002.png" width="44" height="44"></li>
              	<li><img src="images/hotspot_thumb_003.png" width="44" height="44"></li>
                <li><img src="images/hotspot_thumb_004.png" width="44" height="44"></li>
              	<li><img src="images/hotspot_thumb_005.png" width="44" height="44"></li>
                <li><img src="images/hotspot_thumb_006.png" width="44" height="44"></li>
              	<li><img src="images/hotspot_thumb_007.png" width="44" height="44"></li>
                <li><img src="images/hotspot_thumb_008.png" width="44" height="44"></li>
              </ul>
              <div class="btn_hotspot_wrapper">
              	<a href="#" onclick="return createHotspot();" class="btn_dark_blue btn_hotspot">Get My Hotspot!</a>
              </div>
            </div>
          </div>
        </div>
        <!-- // sidebar box -->
      </div>
      
    </div>
    <!-- // sidebar -->    
    <div class="floatfix"></div>
  </div>
  <!-- // content wrapper -->
		</form:form>

	
<!-- // page wrapper -->
