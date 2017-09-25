<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- by Cathy Snider, Strategic Relations, CU Boulder -->
  <!-- 9-20-2017: ADD CANVAS LINK -->

  <xsl:template match="root">
    <div id="mycuinfoprofile">
      
      <script type="text/javascript">
        
        $(document).ready(function() {
        $("div#personalInfo").hide();	
        
        $("a#profileLink").click(function(){
        var pglt_link_state = $(this).attr("aria-expanded");
        $(this).toggleClass("closeProfile");
        $(this).toggleClass("openProfile");
        $("div#personalInfo").slideToggle();
        if (pglt_link_state == "false") {
        $(this).attr("aria-expanded","true");
        $("div#personalInfo").attr("aria-hidden","false");
        }
        
        if (pglt_link_state == "true") {
        $(this).attr("aria-expanded","false");
        $("div#personalInfo").attr("aria-hidden","true");	
        }
        });	
        
        
        $("#d2lLink").attr("href", document.location.href.replace(/\/psp\//, "/psc/").replace(/\/h\/.*$/, "/s/WEBLIB_CU_D2L.ISCRIPT1.FieldFormula.IScript_ShowD2LPagelet"));  
        });
        
      </script>
      
     <script type="text/javascript">

  <xsl:comment> // without this the portal breaks the code
  
  // This creates link for Canvas
  var canvasURL = {
'iepdev' : 'https://cuboulder.beta.instructure.com',
'ieptst' : 'https://cuboulder.test.instructure.com',
'iepstg' : 'https://canvas.colorado.edu',
'iepprd' : 'https://canvas.colorado.edu'
};
var dbLocation = window.location.pathname.match(/\/psp\/([^\/]+)\//)[1];
$('#canvasLink').attr('href', canvasURL[dbLocation]);

  
  
var resDataLink = document.getElementById('profileLink');
resDataLink.onclick = getResidency; 

function getResidency() {

csUrlBuilder = {
  envList :
    {"iepdev" : ["icsdev.dev", "icsdev"],
     "ieptst" : ["icstst.qa", "icstst"],
     "iepstg" : ["icsstg.qa", "icsstg"],
	 "iepsp3" : ["icssp3.dev", "icssp3"],
     "portal" : ["isis-cs.prod", "csprod"]
    },
  env: function() {
	var hostname = window.location.hostname;
	hostname = hostname.substring(0, hostname.indexOf("."))
	return hostname;	
  },
  url : function() {
    var hostname = window.location.hostname;
    hostname = hostname.substring(0, hostname.indexOf("."));
    var env = this.envList[hostname];
    return "https://" + env[0] + ".cu.edu/psc/" + env[1] + "/EMPLOYEE/HRMS/s/WEBLIB_CU_EPVW.ISCRIPT1.FieldFormula.IScript_EPViewer";
  }
}


var currentEnv = csUrlBuilder.env();
console.log(currentEnv);
  
$.ajax({
        url: csUrlBuilder.url() + "?dataset=residency",
        xhrFields: { withCredentials: true }
        }).done(function(data){
        
        var MyJsonObject = data; //entire json set
		var mainResDataset = null;
		var residencyValue = "We are unable to obtain your residency at this time";
        var dataArrayLength = 0; // the number of objects in the dataset
		dataArrayLength = MyJsonObject.datasets.residency.data.length;
		
		if (dataArrayLength != 0) {
			//first object in dataset contains almost everything we need
        	mainResDataset = MyJsonObject.datasets["residency"].data[0]; 
			
       	    window.mainResDataset = mainResDataset;
			//set student type to tuition_res	
        	var studentType = mainResDataset.tuition_res;         
		 // if student is not RES, look at every student group item in the array; if there's a hit change student type to INTL
		 if (studentType != "RES") { 
        for (var i = 0; i &#60; dataArrayLength; i++) { 
        var studentGroupData = MyJsonObject.datasets.residency.data[i].student_group;
        if (studentGroupData == "AITL") {studentType = "INTL";}		 
           
		   }
		  }
        }
			
        console.log("studentType: " + studentType); 
		
        if (mainResDataset == undefined || mainResDataset == null || mainResDataset.length == 0 ){
        console.log("residency undefined"); //leave residencyValue at default
        }
        else { // do the switch statement
		
		switch (studentType) {
    		case "RES": residencyValue = "In-state";
        	break;
    		case "INTL": residencyValue = "International";
       		break;			
			case "NRES": residencyValue = "Out-of-state";
       		break;
    		case "CEES": residencyValue = "Noncredit";
       		break;
    		default: residencyValue = "Your residency status has not been defined."; 
		}
		} //end else 
	
        document.getElementById("myResidencyStatus").innerHTML = residencyValue;
        
        }).fail(function(data, textStatus, errorThrown) {
        console.log(textStatus);
        console.log(errorThrown);
		document.getElementById("myResidencyStatus").innerHTML = "No residency status is available.";
        
        }).always(function() {});
        
        }
     //  	 </xsl:comment>
        </script>
        
        <h2 class="element-invisible">Quick Links</h2>
        
        <!-- process the affiliations for email -->
        <xsl:apply-templates select="demographicData/affiliations" />
        
        <!-- create Desire2Learn link -->
        <xsl:if test="lms='CULEARN'">
          <div class="link"><a href="#" id="d2lLink" target="_blank">Desire2Learn</a></div>
        </xsl:if>
        <!-- process personal info -->
        <div class="link"><h2><a href="javascript:void(0);" id="profileLink" class="closeProfile" aria-controls="personalInfo" aria-expanded="false">Profile &amp; Settings</a></h2></div>
        
        <div class="toggle_content" id="personalInfo" aria-hidden="true">
          <table class="tbl-profile" role="presentation">
            <tr>
              <td colspan="2">
                <h3>Personal Info</h3>
              </td>
            </tr>
            
            <xsl:apply-templates select="demographicData" />
            <xsl:if test="hr_id">
              <tr>
                <td>
                  <strong>Employee ID:</strong>
                </td>
                <td>
                  <xsl:value-of select="hr_id" />
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="cs_id">
              <tr>
                <td>
                  <strong>Student ID:</strong>
                </td>
                <td>
                  <xsl:value-of select="cs_id" />
                </td>
              </tr>
            </xsl:if>
            <xsl:apply-templates select="collegeDatas" />
            <tr>
              <td>
                <strong>Residency for Tuition Purposes:</strong>
              </td>
              <td><div id="myResidencyStatus"></div>
              </td>
            </tr>
          </table>
          <!-- create helpful links -->
          <table class="tbl-profile" role="presentation">
            <tr>
              <td><h3>Account Settings</h3>
                <ul id="helpfullinks">              
                <li><a href="http://cuidm.colorado.edu/?SelectAccessData=true" target="_blank">IdentiKey Options</a></li>
                <li><a href="../../HRMS/c/SA_LEARNER_SERVICES.SSS_STUDENT_CENTER.GBL#tile-7">Manage Profile and Privacy</a></li>
              </ul>
</td>
     </tr>
            
          </table>
        </div>
    </div>
    
  </xsl:template>
  <xsl:template match="demographicData">
    <tr>
      <td>
        <strong>Name:</strong>
      </td>
      <td>
        <xsl:value-of select="prefFirstName" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="prefLastName" />
      </td>
    </tr>
    
  </xsl:template>
  <xsl:template match="collegeDatas">
    <xsl:apply-templates select="collegeData"></xsl:apply-templates>	
    
  </xsl:template>
  
  
  <xsl:template match="collegeDatas">
    <xsl:for-each select="collegeData">
      <tr>
        <td>
          <strong>College:</strong>
        </td>
        <td>
          <xsl:value-of select="primaryCollege" />
        </td>
      </tr>
      <xsl:if test="primaryMajor != '' ">
        <tr>
          <td>
            <strong>Major:</strong>
          </td>
          <td>
            <!-- test for improperly escaped ampersands in data field -->
            <xsl:choose>
              <xsl:when test="contains(primaryMajor, '&amp;amp;')">
                
                <xsl:value-of select="substring-before(primaryMajor, '&amp;amp;')"></xsl:value-of>
                <xsl:text> &amp; </xsl:text>
                <xsl:value-of select="substring-after(primaryMajor, '&amp;amp;')"></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="primaryMajor" />
              </xsl:otherwise>
            </xsl:choose>
            
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="secondaryMinor != '' ">
        <tr>
          <td>
            <strong>Minor:</strong>
          </td>
          <td>
            <!-- test for improperly escaped ampersands in data field -->	
            <xsl:choose>
              <xsl:when test="contains(secondaryMinor, '&amp;amp;')">
                
                <xsl:value-of select="substring-before(secondaryMinor, '&amp;amp;')"></xsl:value-of>
                <xsl:text> &amp; </xsl:text>
                <xsl:value-of select="substring-after(secondaryMinor, '&amp;amp;')"></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="secondaryMinor" />
              </xsl:otherwise>
            </xsl:choose>
            
            
          </td>
        </tr>
      </xsl:if>
      
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="demographicData/affiliations">
    <xsl:if test="(affiliation = 'FACULTY') or (affiliation = 'ADVISOR')">
    <div class="link"><a href="javascript:void(0);" id="canvasLink" target="_blank">Canvas</a></div>
    <div class="link"><a href="https://outlook.office365.com/" target="_blank">Office 365 Outlook</a></div>
    </xsl:if>
    <xsl:if test="affiliation = 'STUDENT'"><div class="link"><a href="http://gmail.colorado.edu" target="_blank">Gmail</a></div></xsl:if>		
  </xsl:template>
  
  
  
</xsl:stylesheet>
