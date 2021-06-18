import lg from 'lightgallery'

// Had to modify this lg extension to add lazy loading to thumbnails
//import lgThumbnail from './lg-thumbnail-modified'

import lgThumbnail from 'lg-thumbnail-modified'
import lgFs from 'lightgallery/plugins/fullscreen'
import lgHash from 'lightgallery/plugins/hash'
import '../stylesheets/_gallery.sass'

document.addEventListener("DOMContentLoaded", function(event) {
  const el = document.getElementById('lightgallery')
  console.log({el})
  lg(el, {
    plugins: [lgThumbnail, lgFs, lgHash],
    thumbnail: true,
    thumbWidth: 100,
    thumbContHeight: 160,
    fullScreen: true,
  });
});
