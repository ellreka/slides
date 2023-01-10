slides=($(ls presentations))

cat > dist/index.html <<'EOF'
  <html>
  <head>
    <title>ellreka slides</title>
  </head>
  <body>
    <h1>slides</h1>
    <ul>
EOF

for slide in ${slides[@]}; do
  cat >> dist/index.html <<EOF
    <li>
      <a href="https://ellreka.github.io/slides/$slide">
        $slide
      </a>
    </li>
EOF
done

cat >> dist/index.html <<'EOF'
    </ul>
  </body>
  </html>
EOF