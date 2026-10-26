```{=html}
<% const categories = [...new Set(items.flatMap(item => item.categories || []))].sort((a, b) => a.localeCompare(b)); %>
<nav class="article-filters quarto-listing-category" aria-label="Filter articles by category">
  <button type="button" class="category active" data-category="" aria-pressed="true">All</button>
  <% for (const category of categories) { %>
  <button type="button" class="category" data-category="<%- btoa(encodeURIComponent(category)) %>" aria-pressed="false"><%- category %></button>
  <% } %>
</nav>
<div class="article-list list">
<% for (const item of items) { %>
  <article class="article-entry" <%= metadataAttrs(item) %>>
    <h2 class="listing-title"><a href="<%- item.path %>"><%= item.title %></a></h2>
    <div class="article-meta">
      <% if (item.draft) { %>
      <span class="draft-label"><%= item['layout-mock'] ? 'Layout mock · Draft' : 'Draft' %></span>
      <% } %>
      <% if (item.date) { %><span class="listing-date"><%- item.date %></span><% } %>
      <% for (const category of item.categories || []) { %>
      <a href="#category=<%- encodeURIComponent(category) %>" class="article-category" data-article-category="<%- btoa(encodeURIComponent(category)) %>"><%- category %></a>
      <% } %>
    </div>
    <% if (item.description) { %><p class="listing-description"><%= item.description %></p><% } %>
  </article>
<% } %>
</div>
```