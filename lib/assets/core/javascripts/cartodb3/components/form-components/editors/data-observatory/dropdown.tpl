<div class="CDB-InputText CDB-Text is-cursor js-button u-ellipsis
  <% if (isDisabled) { %> is-disabled <% } %>
  <% if (!label) { %> is-empty <% } %>
  <% if (isNull) { %> is-empty <% } %>"
  tabindex="0">
  <% if (isLoading) { %>
    <div class="CDB-LoaderIcon CDB-LoaderIcon--small is-dark u-iBlock">
      <svg class="CDB-LoaderIcon-spinner" viewBox="0 0 50 50">
        <circle class="CDB-LoaderIcon-path" cx="25" cy="25" r="20" fill="none"></circle>
      </svg>
    </div>
    <span class="u-lSpace u-secondaryTextColor"><%- _t('components.backbone-forms.select.loading') %></span>
  <% } else { %>
    <% if (isEmpty) { %>
      <%- _t('components.backbone-forms.select.empty') %>
    <% } else { %>
      <%- placeholder || label || _t('components.backbone-forms.select.placeholder', { keyAttr: keyAttr }) %>
    <% } %>
  <% } %>
</div>
