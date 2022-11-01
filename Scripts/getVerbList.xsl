<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs t" version="2.0">
  <xsl:output omit-xml-declaration="yes" method="text"/>


  <xsl:param name="lang">por</xsl:param>
  <xsl:param name="list">noisy</xsl:param>

  <xsl:template match="/">
    <xsl:variable name="listName">manual</xsl:variable>
   
   <xsl:message>lang is <xsl:value-of 
    select="$lang"/> list-type is <xsl:value-of select="$listName"/>
   </xsl:message>
   
    <xsl:choose>
      <xsl:when test="$list eq 'pure'">
     <xsl:message>Preparing a pure list</xsl:message>
   
        <xsl:for-each
          select="lists/list[@xml:lang = $lang][@n = $listName]/lemma[@inner = 'y']/@form">
          <xsl:sort/>
          <!--<xsl:message><xsl:value-of select="."/></xsl:message>
-->
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:when>
  <!--    <xsl:when test="$list eq 'noisy'">
       <xsl:message>Preparing a noisy list </xsl:message>   
        <xsl:for-each
          select="lists/list[@xml:lang = $lang][@n = $listName]/lemma/@form">
          <xsl:sort/>
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:when>-->
     
      <xsl:otherwise>
       <xsl:message>Preparing an impure list</xsl:message>
        <xsl:for-each select="lists/list[@xml:lang = $lang][@n = $listName]/lemma/@form">
         <xsl:sort/>
         <xsl:value-of select="."/>    
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
