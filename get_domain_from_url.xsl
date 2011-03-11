<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

<!--
    get_domain_from_url
    Returns the domain name, without the tld, from a given url.

    Is function calls itself recursively. Each part of the url, which is not
    part of the domain name is erased until the domain name is the last part.

    <xsl:call-template name="get_domain_from_url">
        <xsl:with-param name="" select="'https://github.com/dabio'"/>
    </xsl:call-template>
    Returns: github
-->
<xsl:template name="get_domain_from_url">
    <xsl:param name="url"/>

    <xsl:choose>
        <!-- erase the protocol part -->
        <xsl:when test="contains($url, '://')">
            <xsl:call-template name="get_domain_from_url">
                <xsl:with-param name="url" select="substring-after($url, '://')"/>
            </xsl:call-template>
        </xsl:when>
        <!-- erase the directories -->
        <xsl:when test="contains($url, '/')">
            <xsl:call-template name="get_domain_from_url">
                <xsl:with-param name="url" select="substring-before($url, '/')"/>
            </xsl:call-template>
        </xsl:when>
        <!-- erase the subdomains -->
        <xsl:when test="contains(substring-after($url, '.'), '.')">
            <xsl:call-template name="get_domain_from_url">
                <xsl:with-param name="url" select="substring-after($url, '.')"/>
            </xsl:call-template>
        </xsl:when>
        <!-- now we just have to remove the tdl and are finished -->
        <xsl:otherwise>
            <xsl:value-of select="substring-before($url, '.')"/>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

</xsl:stylesheet>
