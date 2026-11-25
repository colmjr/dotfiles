;;; dashboard.el --- Recent files and startup dashboard -*- lexical-binding: t; -*-

;;; Code:

(use-package recentf
  :ensure nil
  :custom
  (recentf-max-saved-items 200)
  :config
  (recentf-mode 1))

(use-package dashboard
  :ensure t
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-projects-backend 'projectile)
  (dashboard-items
   '((recents . 8)
     (projects . 5)
     (agenda . 5)))
  :config
  (dashboard-setup-startup-hook))

(use-package elfeed
  :ensure t
  :bind ("C-x w" . elfeed)
  :config
  (setq elfeed-feeds
		'(("https://planet.emacslife.com/atom.xml" emacs)
		  ("https://kivooeo.github.io/atom.xml" blog rust compiler)
		  ("https://without.boats/index.xml" blog rust compiler)
		  ("https://nullprogram.com/feed/" blog)
		  ("https://blog.rust-lang.org/feed" rust)
		  ("https://eli.thegreenplace.net/feeds/all.atom.xml" blog compiler)
		  ("https://matklad.github.io/feed" blog rust compiler)
		  ("https://www.ralfj.de/blog/feed.xml" blog rust compiler)
		  ("https://bartoszmilewski.com/feed/" blog)
		  ("https://www.masteringemacs.org/feed" emacs)
		  ("https://matt.might.net/articles/feed.rss" blog)
		  ("https://www.johndcook.com/blog/feed/" math modeling)
		  ("https://feeds.feedburner.com/StatisticalModeling" math modeling statistics)
		  ("https://johncarlosbaez.wordpress.com/feed/" math modeling category-theory)
		  ("https://www.stochasticlifestyle.com/feed/" math modeling julia numerical)
		  ("https://www.allendowney.com/blog/feed/" math modeling simulation)
		  ("https://topos.institute/blog/index.xml" math modeling category-theory)
		  ("https://orinanobworld.blogspot.com/feeds/posts/default" math modeling optimization)
		  ("https://www.ralfj.de/blog/feed.xml" blog rust compiler))))

;;; dashboard.el ends here
