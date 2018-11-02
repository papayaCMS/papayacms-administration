<?xml version="1.0" encoding="iso-8859-1"?>
<!--
  ~ papaya CMS
  ~
  ~ @copyright 2000-2018 by papayaCMS project - All rights reserved.
  ~ @link http://www.papaya-cms.com/
  ~ @license http://www.gnu.org/licenses/old-licenses/gpl-2.0.html GNU General Public License, version 2
  ~
  ~  You can redistribute and/or modify this script under the terms of the GNU General Public
  ~  License (GPL) version 2, provided that the copyright and license notes, including these
  ~  lines, remain unmodified. papaya is distributed in the hope that it will be useful, but
  ~  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  ~  FOR A PARTICULAR PURPOSE.
  -->

<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:popup="http://papaya-cms.com/administration/popup"
  exclude-result-prefixes="popup">

  <popup:popup>
    <popup:phrases>
      <popup:phrase>Select Geo Position</popup:phrase>
      <popup:phrase>OK</popup:phrase>
      <popup:phrase>Cancel</popup:phrase>
    </popup:phrases>
    <popup:options>
      <popup:option name="PAPAYA_GMAPS_API_KEY"> </popup:option>
    </popup:options>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
      <title><xsl:value-of select="//popup:phrase[@identifier='Select Geo Position']"/></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="../styles/css.popup" />
        <script
          src="http://maps.google.com/maps?file=api&amp;v=2&amp;key={//popup:options[@name='PAPAYA_GMAPS_API_KEY']}"
          type="text/javascript"> </script>
        <script type="text/javascript">
          var PAPAYA_GMAPS_DEFAULT_POSITION = '<xsl:value-of select="//popup:options[@name='PAPAYA_GMAPS_DEFAULT_POSITION']"/>'.split(' ');
        </script>
        <script type="text/javascript">
          //<![CDATA[
          function load() {
            if (GBrowserIsCompatible()) {
              var map = new GMap2(document.getElementById("map"));
              map.setCenter(new GLatLng(PAPAYA_GMAPS_DEFAULT_POSITION[0], PAPAYA_GMAPS_DEFAULT_POSITION[1]), 13);
              map.addControl(new GLargeMapControl());
              map.addControl(new GMapTypeControl());
              GEvent.addListener(map, "click", function(overlay, point){
                map.clearOverlays();
                if (point) {
                  map.addOverlay(new GMarker(point));
                  aCurrentData.lat = point.lat();
                  aCurrentData.lng = point.lng();
                  msg = "Lat: "+point.y.toString()+" Long: "+point.x.toString();
                  document.getElementById("editPage").value = msg;
                }
              });
            }
          }

          function CPTD(p,t) {
            var r='';
            var degrees = Math.floor(Math.abs(p));
            var minutes = Math.floor((Math.abs(p)-degrees)*60);
            var seconds = (((Math.abs(p)-degrees)*60-minutes)*60).toFixed(2);
            var orientation;
            if (t=='lat'){
              if (p > 0) {
                orientation='N';
              } else {
                orientation='S';
              }
            } else {
              if (p > 0) {
                orientation='O';
              } else {
                orientation='W';
              }
            }
            return degrees + '? '+minutes+'\' '+seconds+'\'\' '+orientation;
          }

          var aCurrentData = new Array();
          var papayaContext = null;

          function Cancel() {
            if (papayaContext) {
              papayaContext.defer.reject();
            }
            if (!window.frameElement) {
              window.close();
            }
          }

          function Ok() {
            if (papayaContext) {
              papayaContext.defer.resolve(aCurrentData.lat, aCurrentData.lng);
            } else if (typeof linkedObject != 'undefined' && linkedObject != null) {
              if (linkedObject.setGeoPos) {
                linkedObject.setGeoPos(aCurrentData.lat, aCurrentData.lng);
              } else if (linkedObject.value != undefined) {
                linkedObject.value = aCurrentData.lat+","+aCurrentData.lng;
              }
            }
            if (!window.frameElement) {
              window.close();
            }
          }
          //]]>
        </script>
      </head>
      <body id="popup" onload="load()">
        <div class="title">
          <div class="artworkOverlay">
            <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
          </div>
          <h1 id="popupTitle"><xsl:value-of select="//popup:phrase[@identifier='Select Geo Position']"/></h1>
        </div>
        <div id="divLinkModePage">
          <input type="text" class="text" id="editPage" disabled="disabled" style="width: 300px"/>
        </div>
        <div id="map" style="width: 300px; height: 300px"><xsl:text> </xsl:text></div>
        <div class="popupButtonsArea" style="text-align: right; white-space: nowrap;">
          <input type="button" value="{//popup:phrase[@identifier='OK']}" class="dialogButton" onclick="Ok();" papayaLang="DlgBtnOk" />
          <input type="button" value="{//popup:phrase[@identifier='Cancel']}" class="dialogButton" onclick="Cancel();" papayaLang="DlgBtnCancel" />
        </div>
        <div class="footer">
          <div class="artworkOverlay">
            <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
