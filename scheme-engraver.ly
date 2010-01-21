Index: input/regression/scheme-engraver.ly
diff --git a/input/regression/scheme-engraver.ly b/input/regression/scheme-engraver.ly
new file mode 100644
index 0000000000000000000000000000000000000000..ee7f3ea11ed4e5936d27d5f9872c459b41746cc4
--- /dev/null
+++ b/input/regression/scheme-engraver.ly
@@ -0,0 +1,76 @@
+\header {
+
+  texidoc = "\\consists can take a scheme alist as arguments, which
+  should be functions, which will be invoked as engraver functions."
+
+}
+
+\version "2.13.9"
+
+\layout {
+  \context {
+    \Voice
+    \consists
+    #(list
+      (cons 'initialize
+       (lambda (trans)
+	(display (list "initialize"
+		  (ly:context-current-moment
+		   (ly:translator-context trans)) "\n"))))
+      (cons 'start-translation-timestep
+       (lambda (trans)
+	(display (list "start-trans"
+		  (ly:context-current-moment
+		   (ly:translator-context trans)) "\n"))))
+      (cons 'listeners
+       (list
+	(cons 'rest-event (lambda (engraver event)
+			   (let*
+			    ((x (ly:engraver-make-grob engraver 'TextScript event)))
+			    (display (list "caught event" event "\ncreate:\n" x "\n"))
+			    (ly:grob-set-property! x 'text "hi"))
+			   ))
+       ))
+      (cons 'acknowledgers
+       (list
+	(cons 'note-head-interface
+	 (lambda (engraver grob source-engraver)
+	  (display (list "saw head: " grob " coming from " source-engraver))
+	  ))
+	))
+      (cons 'end-acknowledgers
+       (list
+	(cons 'beam-interface
+	 (lambda (engraver grob source-engraver)
+	  (display (list "saw end of beam: " grob " coming from " source-engraver))
+	  ))
+	))
+      (cons 'process-music
+       (lambda (trans)
+	(display (list "process-music"
+		  (ly:context-current-moment
+		   (ly:translator-context trans)) "\n"))))
+      (cons 'process-acknowledged
+       (lambda (trans)
+	(display (list "process-acknowledged"
+		  (ly:context-current-moment
+		   (ly:translator-context trans)) "\n"))))
+      (cons 'start-translation-timestep
+       (lambda (trans)
+	(display (list "stop-trans"
+		  (ly:context-current-moment
+		   (ly:translator-context trans)) "\n"))))
+      (cons 'finalize
+       (lambda (trans)
+	(display (list "finalize"
+		  (ly:context-current-moment
+		   (ly:translator-context trans)) "\n"))))
+    )
+
+		}}
+
+
+\relative {
+  c8[ r c]
+
+}