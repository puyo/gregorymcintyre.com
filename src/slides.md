---
layout: page
title: Slides
---

<ul>
  <% collections.slides.resources.each do |post| %>
    <li>
      <a href="<%= post.relative_url %>"><%= post.data.title %></a>
    </li>
  <% end %>
</ul>
