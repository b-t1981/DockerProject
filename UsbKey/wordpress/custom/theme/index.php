<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <title><?php bloginfo('name'); ?></title>
    <?php wp_head(); ?>
</head>
<body>
    <header>
        <h1><?php bloginfo('name'); ?></h1>
        <p><?php bloginfo('description'); ?></p>
    </header>
    <main>
        <?php
        if (have_posts()) {
            while (have_posts()) {
                the_post();
                the_title('<h2>', '</h2>');
                the_content();
            }
        }
        ?>
    </main>
    <?php wp_footer(); ?>
</body>
</html>
