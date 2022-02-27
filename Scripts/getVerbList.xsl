<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
 exclude-result-prefixes="xs t" version="2.0">
 <xsl:output omit-xml-declaration="yes" method="text"/>

 
 <xsl:param name="lang">por</xsl:param>
 
 <xsl:template match="/">
  <xsl:value-of select='string("textId year verbs innerVerbs")'/>
  <xsl:for-each select="document('/home/lou/Public/ELTeC-data/innerVerbs.xml')//list[@xml:lang=$lang]/lemma/@form">
   <xsl:sort/>
    <xsl:value-of select="."/> <xsl:text> </xsl:text>
  </xsl:for-each></xsl:template>
  

 
  
</xsl:stylesheet>