<#macro kw component="a" rest...>
  <${component}
    class="flex items-center justify-center text-primary-600 hover:text-primary-500"
    <#list rest as attrName, attrValue>
      ${attrName}="${attrValue}"
    </#list>
  >
    <#nested>
  </${component}>
</#macro>
