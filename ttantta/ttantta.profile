<?php
// $Id: ttanttaone.profile,v 0.1 2009/10/26 23:00:00 karlosgliberal Exp $
// webhook 1 
/**
 * Implementation of ttantta_profile_modules().
 */
function ttantta_profile_modules() {

  $modules_list = array(
  'captcha', 'color', 'comment', 'contact', 'content', 'content_copy', 'content_taxonomy', 'content_taxonomy_autocomplete', 'content_taxonomy_options', 'dblog', 'filefield', 'formalter', 'help', 'image_captcha', 'imageapi', 'imageapi_gd', 'imagecache', 'imagecache_ui', 'imagefield', 'imce', 'imce_wysiwyg', 'locale', 'login_destination', 'menu', 'optionwidgets', 'path', 'pathauto', 'search', 'taxonomy', 'text', 'token', 'token_actions',  'trigger', 'update', 'upload', 'views', 'views_export', 'views_ui', 'wysiwyg', 'features', 'context', 'fieldgroup', 'nodereference', 'number', 'userreference', 'statistics', 'tracker', 'comment_notify', 'strongarm'  );

  return $modules_list;
}

  
/**
 * Implementation of hook_profile_details().
 */
function ttantta_profile_details() {
  $description = '<ul><li>Antes de aceptar!! espero que tengas los modulos y el tema zen metidos!!!!</li><li>En uno de estos pasos va a salir un error enorme...pasa de el, no pasa nada</li><li>El módulo filefield tienes que activarlo en admin/build/modules (da error sino) y crear los campos de imagen en los cck blog e historia</li></ul> ';

  return array(
    'name' => 'Ttantta',
    'description' => $description,
  );
}

// function innovationnewsprofile_profile_details
/**
 * Return a list of tasks that this profile supports.
 *
 * @return
 *   A keyed array of tasks the profile will perform during
 *   the final stage. The keys of the array will be used internally,
 *   while the values will be displayed to the user in the installer
 *   task list.
 */
function ttantta_profile_task_list() {
}

/**
 * Implementation of hook_profile_tasks().
 */
function ttantta_profile_tasks(&$task, $url) {
  ttantta_crear_cck();
  ttantta_crear_vocabularios();
  ttantta_cambiar_settings();
  ttantta_crear_views();
  ttantta_crear_blocks();
  ttantta_crear_cck_fields();
  ttantta_modificar_menus();
  ttantta_anadir_permissions();
} 

function ttantta_crear_cck(){
  $noticia_description = st('Enviar noticias al portal.');
  $pagina_description = st('Enviar páginas estáticas al portal.');
  $types = array (
    array(
      'type' => 'pagina',
      'name' => 'Página',
      'module' => 'node',
      'description' => $pagina_description,
      'custom' => TRUE,
      'title_label' => 'Título',
      'has_body' => 0,
      'modified' => TRUE,
      'locked' => FALSE,
    ),

    array(
      'type' => 'noticias',
      'name' => 'Noticias',
      'module' => 'node',
      'description' => $noticia_description,
      'title_label' => 'Título',
      'has_body' => 0,
      'custom' => TRUE,
     'locked' => FALSE,
    ),
  );

  foreach ($types as $type) {
    $type = (object) _node_type_set_defaults($type);
    node_type_save($type);
  }
  // Disable "Promoted to front page" for images.
  variable_set('node_options_noticias', array('status'));
  variable_set('node_options_pagina', array('status'));

  // Allow images to be attached to articles.
  //variable_set('image_attach_noticia', TRUE);

  //opciones de los comentarios 
  variable_set ('comment_anonymous_noticias', 1);
  variable_set ('comment_anonymous_pagina', 0);
  variable_set ('comment_controls_noticias', 3);
  variable_set ('comment_controls_pagina', 3);
  variable_set ('comment_default_mode_noticias', 4);
  variable_set ('comment_default_mode_pagina', 4);
  variable_set ('comment_default_order_noticias', 1);
  variable_set ('comment_default_order_pagina', 1);
  variable_set ('comment_default_per_page_noticias', 50);
  variable_set ('comment_default_per_page_pagina', 50);
  variable_set ('comment_form_location_noticias', 1);
  variable_set ('comment_form_location_pagina', 1);
  variable_set ('comment_noticias', 2);
  variable_set ('comment_preview_noticias', 0);
  variable_set ('comment_preview_pagina', 0);
  variable_set ('comment_subject_field_noticias', 1);
  variable_set ('comment_pagina', 0);

  // opciones de multilenguaje..
  variable_set ('language_content_type_noticias', 0);
  variable_set ('language_content_type_pagina', 0);
  
  // opciones de subida de archivos
  variable_set ('upload_noticias', 1);
  variable_set ('upload_pagina', 1);
 
  //pesos de los campos
  $array = array('title'=>-5, 'menu'=> -4, 'attachments'=>3);
  variable_set ('content_extra_weights_noticias', $array);
  variable_set ('content_extra_weights_pagina', $array);

  // captcha
  variable_set ('captcha_administration_mode', 0);
  variable_set ('captcha_description_en', 'This question is for testing whether you are a human visitor and to prevent automated spam submissions.');
  variable_set ('captcha_description_es', 'Esto es para prevenir el spam');
  variable_set ('captcha_log_wrong_responses', 0);
  variable_set ('captcha_persistence', 1);

  variable_set ('image_captcha_background_color', '#ffffff');
  variable_set ('image_captcha_bilinair_interpolation', 0);
  variable_set ('image_captcha_character_spacing', 1.2);
  variable_set ('image_captcha_code_length', 4);
  variable_set ('image_captcha_distortion_amplitude', 0);
  variable_set ('image_captcha_dot_noise', 0);
  variable_set ('image_captcha_double_vision', 0);
  variable_set ('image_captcha_font', 'BUILTIN');
  variable_set ('image_captcha_foreground_color', '#000000');
  variable_set ('image_captcha_foreground_color_randomness', 100);
  variable_set ('image_captcha_image_allowed_chars', 'QWERTYUIOPLKJHGFDSAZXCVBNM');
  variable_set ('image_captcha_line_noise', 0);
  variable_set ('image_captcha_noise_level', 2);

  db_query("UPDATE {captcha_points} SET module = '%s', type ='%s' WHERE form_id = '%s' ", 'image_captcha', 'Image', 'comment_form');

  //pathauto
  variable_set ('pathauto_node_noticias_pattern', 'noticias/[title-raw]');
  variable_set ('pathauto_node_pattern', '');
}

/**
 * Añadir vocabularios.
 */
function ttantta_crear_vocabularios(){
  $noticias_tags_description = st('Tags de las noticias');
  $vocabulary_noticias_tags = array(
    'name' => st('Noticias tags'),
    'description' => $noticias_tags_description,
    'multiple' => 1,
    'required' => 0,
    'hierarchy' => 1,
    'relations' => 1,
    'tags' => 1,
    'nodes' =>'',
  );
  taxonomy_save_vocabulary($vocabulary_noticias_tags);
 // los pathauto de los vocabularios
  variable_set ('pathauto_taxonomy_1_pattern', 'noticias/tags/[catpath-raw]');
  variable_set ('pathauto_taxonomy_pattern', '[vocab-raw]/tags/[catpath-raw]');

}



/**
 * Modifica configuraciones.
 */
function ttantta_cambiar_settings(){
  variable_set('theme_default', 'yelow_tt1');
  // quitar el bloque search por defecto del tema
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_search'] = FALSE;
  variable_set('theme_settings', $theme_settings);

  // Formulario contacto 
  db_query("INSERT INTO {contact} (category, recipients, weight, selected) VALUES('%s', '%s', %d, %d)", 'Contactar', 'aitor@investic.net', 0, 1);
 
  // Basic Drupal settings.
  variable_set('filter_default_format', 1);
  db_query("UPDATE {filter_formats} SET roles = '%s' WHERE format = %d", ',3,', 2);
  
  // las fechas
  variable_set('date_default_timezone', 7200);
  variable_set('date_first_day', 1);
  variable_set('date_format_long', 'l, j F, Y - H:i');
  variable_set('date_format_long_custom', 'l, F j, Y - H:i');
  variable_set('date_format_medium', 'D, d/m/Y - H:i');
  variable_set('date_format_medium_custom', 'D, m/d/Y - H:i');
  variable_set('date_format_short', 'd/m/Y');
  variable_set('date_format_short_custom', 'd/m/Y');

   // configurar imagecache
  db_query("INSERT INTO {imagecache_preset} (presetid, presetname) VALUES(%d, '%s')", 1, 'noticias_full');
  db_query("INSERT INTO {imagecache_preset} (presetid, presetname) VALUES(%d, '%s')", 2, 'noticias_teaser');

  db_query("INSERT INTO {imagecache_action} (actionid, presetid, weight, module, action, data) VALUES(%d, %d, %d, '%s', '%s', '%s')", 1, 1, 0, 'imagecache', 'imagecache_scale', 'a:3:{s:5:"width";s:3:"300";s:6:"height";s:0:"";s:7:"upscale";i:0;}');
  db_query("INSERT INTO {imagecache_action} (actionid, presetid, weight, module, action, data) VALUES(%d, %d, %d, '%s', '%s', '%s')", 2, 2, 0, 'imagecache', 'imagecache_scale', 'a:3:{s:5:"width";s:3:"150";s:6:"height";s:0:"";s:7:"upscale";i:0;}');

  //configurar pagina de inicio
  variable_set('site_frontpage', 'home');
  
  //configurar pagina bienvenida a los logados
  variable_set('ld_condition_type', 'snippet');
  variable_set('ld_condition_snippet', 'global $user;
  if ($user->uid >1) {
    return TRUE ;}');
  variable_set('ld_destination', '0');
  variable_set('ld_url_destination', 'gestion');
  variable_set('ld_url_type', 'static');
  
  // indicar que solo pueda añadir usuarios el admin
  variable_set('user_register', '0');

  // configurar las opciones de las estadisticas
  variable_set('statistics_count_content_views', '1');
  variable_set('statistics_day_timestamp', '1243510685');
  variable_set('statistics_enable_access_log', '1');
  variable_set('statistics_flush_accesslog_timer', '2419200');

  // configurar el modulo comment notify

  variable_set('comment_notify_available_alerts', array(1=>1, 2=>2));
  variable_set('comment_notify_default_anon_mailalert', 0 );
  $email_to = 'Hola !name,

  !commname ha sido comentado en: "!node_title"

  el post es sobre
  ----
  !node_teaser
  ----

  Puedes ver el comentario en
  !comment_url

  Puedes darte de baja para dejar de recibir emails con las respuestas de este post en el siguiente link: 
   !link1


   Gracias por sus comentarios


   Webmaster de !site
   !mission
   !uri';
  variable_set('comment_notify_default_mailtext', $email_to);
  variable_set('comment_notify_default_registered_mailalert', 1);
  variable_set('comment_notify_node_types', array('noticias' => 'noticias', 'pagina' => 'pagina' ));
  $email_default = 'Hola !name,

  Tienes un comentario nuevo en: "!node_title"

  Puedes ver el comentario en 
  !comment_url

  Recibirá e-mails de este tipo para todas las respuestas de sus posts. Puede desactivar esta opción en la configuración de su cuenta.


  Webmaster de !site
  !mission
  !uri';
  variable_set('node_notify_default_mailtext', $email_default );

  // IMCE
  
  $imce_profiles[1] = array(
    'name' => 'User-1',
    'filesize' => 0,
    'quota' => 0,
    'tuquota' => 0,
    'extensions' => '*',
    'dimensions' => '1200x1200',
    'filenum' => 0,
    'directories' => Array(
      0 => Array(
        'name' => '.',
        'subnav' => 1,
        'browse' => 1,
        'upload' => 1,
        'thumb' => 1,
        'delete' => 1,
        'resize' => 1,
      ),
    ),
    'thumbnails' => Array(
      0 => Array(
        'name' => 'Small',
        'dimensions' => '90x90',
        'prefix' => 'small_',
        'suffix' => '', 
      ),
      1 => Array(
        'name' => 'Medium',
        'dimensions' => '120x120',
        'prefix' => 'medium_',
        'suffix' => '', 
      ),
      2 => Array(
        'name' => 'Large',
        'dimensions' => '180x180',
        'prefix' => 'large_',
        'suffix' => '',
      ),
    ),
  );
  $imce_profiles[2] = array(
    'name' => 'Sample profile',
    'filesize' => 1,
    'quota' => 2,
    'tuquota' => 0,
    'extensions' => 'gif png jpg jpeg',
    'dimensions' => '800x600',
    'filenum' => 1,
    'directories' => Array(
      0 => Array(
        'name' => 'u%uid',
        'subnav' => 0,
        'browse' => 1,
        'upload' => 1,
        'thumb' => 1,
        'delete' => 1,
        'resize' => 1,
      ),
    ),
    'thumbnails' => Array(
      0 => Array(
        'name' => 'Thumb',
        'dimensions' => '90x90',
        'prefix' => 'thumb_',
        'suffix' =>'', 
      ),
    ),
  );
  $imce_profiles[3] = array(
    'name' => 'gestion',
    'filesize' => 1,
    'quota' => 100,
    'tuquota' => 0,
    'extensions' => 'gif png jpg jpeg',
    'dimensions' => '800x600',
    'filenum' => 1,
    'directories' => Array(
      0 => Array(
        'name' => 'u%uid',
        'subnav' => 1,
        'browse' => 1,
        'upload' => 1,
        'thumb' => 1,
        'delete' => 1,
        'resize' => 1,
      ),
    ),
    'thumbnails' => Array(
      0 => Array(
        'name' => 'Thumb',
        'dimensions' => '90x90',
        'prefix' => 'thumb_',
        'suffix' => '',
      ),
    ),
  );

  variable_set ('imce_profiles', $imce_profiles);

  $imce_setting = 'a:21:{s:7:"default";i:1;s:11:"user_choose";i:0;s:11:"show_toggle";i:1;s:5:"theme";s:8:"advanced";s:8:"language";s:2:"en";s:7:"buttons";a:8:{s:7:"default";a:17:{s:4:"bold";i:1;s:6:"italic";i:1;s:9:"underline";i:1;s:13:"strikethrough";i:1;s:11:"justifyleft";i:1;s:13:"justifycenter";i:1;s:12:"justifyright";i:1;s:11:"justifyfull";i:1;s:7:"bullist";i:1;s:7:"numlist";i:1;s:4:"link";i:1;s:6:"unlink";i:1;s:5:"image";i:1;s:9:"backcolor";i:1;s:4:"code";i:1;s:2:"hr";i:1;s:5:"paste";i:1;}s:5:"advhr";a:1:{s:5:"advhr";i:1;}s:11:"contextmenu";a:1:{s:11:"contextmenu";i:1;}s:14:"directionality";a:1:{s:3:"rtl";i:1;}s:8:"emotions";a:1:{s:8:"emotions";i:1;}s:4:"font";a:2:{s:10:"fontselect";i:1;s:14:"fontsizeselect";i:1;}s:5:"paste";a:2:{s:9:"pastetext";i:1;s:9:"pasteword";i:1;}s:4:"imce";a:1:{s:4:"imce";i:1;}}s:11:"toolbar_loc";s:3:"top";s:13:"toolbar_align";s:4:"left";s:8:"path_loc";s:6:"bottom";s:8:"resizing";i:1;s:11:"verify_html";i:1;s:12:"preformatted";i:0;s:22:"convert_fonts_to_spans";i:1;s:17:"remove_linebreaks";i:1;s:23:"apply_source_formatting";i:0;s:27:"paste_auto_cleanup_on_paste";i:0;s:13:"block_formats";s:32:"p,address,pre,h2,h3,h4,h5,h6,div";s:11:"css_setting";s:4:"none";s:8:"css_path";s:0:"";s:11:"css_classes";s:0:"";s:13:"form_build_id";s:37:"form-d2cc743d38561ae0422ae643c679c111";}';

  db_query("DELETE FROM {wysiwyg} WHERE format > %d",0 );
  db_query("INSERT INTO {wysiwyg} VALUES (%d, '%s', '%s')", 1, '', NULL);
  db_query("INSERT INTO {wysiwyg} VALUES (%d, '%s', '%s')", 2, 'tinymce', $imce_setting);

  $imce_roles_profiles = array ( 3 => array('pid' => 3), 2 => array('pid' =>0 ), 1 => array('pid' =>0));
  variable_set ('imce_roles_profiles', $imce_roles_profiles);
}




function ttantta_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    // Set default for site name field.
    $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
  }
}


function ttantta_crear_views() {
  // Vista de las noticias
  db_query("INSERT INTO {views_view} (`vid`, `name`, `description`, `tag`, `view_php`, `base_table`, `is_cacheable`) VALUES (%d, '%s', '%s', '%s', %b, '%s', %d)", 1, 'noticias', 'Listado de las noticias.', 'noticias', '', 'node', 0);
  
  $view_page1 = 'a:6:{s:4:"path";s:4:"home";s:14:"items_per_page";i:5;s:8:"defaults";a:4:{s:14:"items_per_page";b:0;s:6:"offset";b:0;s:9:"use_pager";b:0;s:13:"pager_element";b:0;}s:6:"offset";i:0;s:9:"use_pager";s:1:"1";s:13:"pager_element";i:0;}';

  $view_page2 = 'a:7:{s:4:"path";s:8:"noticias";s:8:"defaults";a:4:{s:14:"items_per_page";b:0;s:6:"offset";b:0;s:9:"use_pager";b:0;s:13:"pager_element";b:0;}s:14:"items_per_page";i:10;s:6:"offset";i:0;s:9:"use_pager";s:1:"1";s:13:"pager_element";i:0;s:4:"menu";a:5:{s:4:"type";s:6:"normal";s:5:"title";s:8:"Noticias";s:11:"description";s:0:"";s:4:"name";s:14:"menu-principal";s:6:"weight";s:1:"0";}}';

  $view_feed1 = 'a:10:{s:10:"row_plugin";s:8:"node_rss";s:11:"row_options";a:2:{s:12:"relationship";s:4:"none";s:11:"item_length";s:7:"default";}s:14:"items_per_page";i:30;s:8:"defaults";a:4:{s:14:"items_per_page";b:0;s:6:"offset";b:0;s:9:"use_pager";b:0;s:13:"pager_element";b:0;}s:6:"offset";i:0;s:9:"use_pager";b:0;s:13:"pager_element";i:0;s:14:"sitename_title";i:1;s:4:"path";s:13:"noticias/feed";s:8:"displays";a:3:{s:7:"default";s:7:"default";s:6:"page_1";s:6:"page_1";s:6:"page_2";s:6:"page_2";}}';

  $view_default = 'a:9:{s:10:"row_plugin";s:4:"node";s:11:"row_options";a:4:{s:12:"relationship";s:4:"none";s:10:"build_mode";s:6:"teaser";s:5:"links";i:1;s:8:"comments";i:0;}s:7:"filters";a:1:{s:4:"type";a:10:{s:8:"operator";s:2:"in";s:5:"value";a:1:{s:8:"noticias";s:8:"noticias";}s:5:"group";s:1:"0";s:7:"exposed";b:0;s:6:"expose";a:2:{s:8:"operator";b:0;s:5:"label";s:0:"";}s:2:"id";s:4:"type";s:5:"table";s:4:"node";s:5:"field";s:4:"type";s:8:"override";a:1:{s:6:"button";s:8:"Override";}s:12:"relationship";s:4:"none";}}s:5:"sorts";a:1:{s:7:"created";a:7:{s:5:"order";s:4:"DESC";s:11:"granularity";s:6:"second";s:2:"id";s:7:"created";s:5:"table";s:4:"node";s:5:"field";s:7:"created";s:8:"override";a:1:{s:6:"button";s:8:"Override";}s:12:"relationship";s:4:"none";}}s:5:"title";s:0:"";s:14:"items_per_page";i:4;s:6:"offset";i:0;s:5:"empty";s:536:"Bienvenido/a a tu nuevo TTANTTAONE

Por favor sigue estos pasos para comenzar a usar tu sitio:

1. <strong>Cambia tu contraseña.</strong>
- <a href="/user">Inicia sesión</a>.
- <a href="/user">Configura tu cuenta</a>.
- Haz click en la pestaña de <a href="/user/3/edit">editar</a>.

2. Empieza a <strong>crear contenidos</strong> desde tu <a href="/gestion">panel de gestión</a>.

Tiene más información en la documentación entregada. También dispones de un télefono (902 105 683) y un mail de soporte (soporte@ttanttaone.net). ";s:12:"empty_format";s:1:"2";}';

  db_query("INSERT INTO {views_display} (`vid`, `id`, `display_title`, `display_plugin`, `position`, `display_options`) VALUES (%d, '%s', '%s', '%s', %d, %b)", 1, 'page_1', 'pagina_home', 'page', 2, $view_page1);
  db_query("INSERT INTO {views_display} (`vid`, `id`, `display_title`, `display_plugin`, `position`, `display_options`) VALUES (%d, '%s', '%s', '%s', %d, %b)", 1, 'page_2', 'pagina_view', 'page', 3, $view_page2);
  db_query("INSERT INTO {views_display} (`vid`, `id`, `display_title`, `display_plugin`, `position`, `display_options`) VALUES (%d, '%s', '%s', '%s', %d, %b)", 1, 'default', 'Defaults', 'default', 1, $view_default);
  db_query("INSERT INTO {views_display} (`vid`, `id`, `display_title`, `display_plugin`, `position`, `display_options`) VALUES (%d, '%s', '%s', '%s', %d, %b)", 1, 'feed_1', 'Feed', 'feed', 4, $view_feed1);

}

/*
 * Modify the block settings.
 */
function ttantta_crear_blocks() {

   db_query("INSERT INTO {blocks} (module, delta, theme, status, weight, region, custom, throttle, visibility, cache) VALUES ('%s', '%s', '%s', %d, %d, '%s', %d, %d, %d, %d)", 'menu', 'menu-principal', 'yelow_tt1', 1, -6, 'left', 0, 0, 0, -1);
   db_query("INSERT INTO {blocks} (module, delta, theme, status, weight, region, custom, throttle, visibility, title, cache) VALUES ('%s', '%s', '%s', %d, %d, '%s', %d, %d, %d, '%s', %d)", 'search', '0', 'yelow_tt1', 1, -6, 'left', 0, 0, 0, '<none>', -1);
   db_query("INSERT INTO {blocks} (module, delta, theme, status, weight, region, custom, throttle, visibility, cache) VALUES ('%s', '%s', '%s', %d, %d, '%s', %d, %d, %d, %d)", 'user', '1', 'yelow_tt1', 1, -9, 'left', 0, 0, 0, -1);
   db_query("INSERT INTO {blocks} (module, delta, theme, status, weight, region, custom, throttle, visibility, pages, title, cache) VALUES ('%s', '%s', '%s', %d, %d, '%s', %d, %d, %d, '%s', '%s', %d)", 'user', '0', 'yelow_tt1', 1, -10, 'content', 0, 0, 1, 'gestion', '', -1);
   db_query("INSERT INTO {blocks_roles} (module, delta, rid) VALUES ('%s', %d, %d)", 'user', '1', 2);
}


 
function ttantta_crear_cck_fields() {
 $noticias_entradilla = array (
    'label' => 'Entradilla',
    'field_name' => 'field_noticias_entradilla',
    'type' => 'text',
    'widget_type' => 'text_textarea',
    'change' => 'Change basic information',
    'weight' => '-3',
    'rows' => '5',
    'size' => 60,
    'description' => '<p class="ayuda-link">
<p class="enlace">Ayuda</p></p>
<p class="descripcion">Este campo se mostrará como resumen en la portada y en la noticia. <br> (Este campo es obligatorio y no puede omitirse)</p>
',
    'default_value' => 
    array (
      0 => 
      array (
        'value' => '',
        'format' => '2',
        '_error_element' => 'default_value_widget][field_noticias_entradilla][0][value',
      ),
    ),
    'default_value_php' => '',
    'default_value_widget' => NULL,
    'group' => false,
    'required' => 1,
    'multiple' => '0',
    'text_processing' => '1',
    'max_length' => '',
    'allowed_values' => '',
    'allowed_values_php' => '',
    'op' => 'Guardar configuraciones del campo',
    'module' => 'text',
    'widget_module' => 'text',
    'columns' => 
    array (
      'value' => 
      array (
        'type' => 'text',
        'size' => 'big',
        'not null' => false,
        'sortable' => true,
        'views' => true,
      ),
      'format' => 
      array (
        'type' => 'int',
        'unsigned' => true,
        'not null' => false,
        'views' => false,
      ),
    ),
    'display_settings' => 
    array (
      'weight' => '-3',
      'parent' => '',
      'label' => 
      array (
        'format' => 'hidden',
      ),
      'teaser' => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
      'full' => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
      4 => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
    ),
  );

  $noticias_cuerpo = array(
    'label' => 'Noticia completa',
    'field_name' => 'field_noticias_cuerpo',
    'type' => 'text',
    'widget_type' => 'text_textarea',
    'change' => 'Change basic information',
    'weight' => '-2',
    'rows' => '20',
    'size' => 60,
    'description' => '<p class="ayuda-link">
<p class="enlace">Ayuda</p></p>
<p class="descripcion">Este campo sólo se mostrará en la noticia, y puede contenter texto, imágenes, vídeos, etc.<br>(Este campo es obligatorio y no puede omitirse) </p>
',
    'default_value' => 
    array (
      0 => 
      array (
        'value' => '',
        'format' => '2',
        '_error_element' => 'default_value_widget][field_noticias_cuerpo][0][value',
      ),
    ),
    'default_value_php' => '',
    'default_value_widget' => 
    array (
      'field_noticias_cuerpo' => 
      array (
        0 => 
        array (
          'value' => '',
          'format' => '2',
          '_error_element' => 'default_value_widget][field_noticias_cuerpo][0][value',
        ),
      ),
    ),
    'group' => false,
    'required' => 1,
    'multiple' => '0',
    'text_processing' => '1',
    'max_length' => '',
    'allowed_values' => '',
    'allowed_values_php' => '',
    'op' => 'Guardar configuraciones del campo',
    'module' => 'text',
    'widget_module' => 'text',
    'columns' => 
    array (
      'value' => 
      array (
        'type' => 'text',
        'size' => 'big',
        'not null' => false,
        'sortable' => true,
        'views' => true,
      ),
      'format' => 
      array (
        'type' => 'int',
        'unsigned' => true,
        'not null' => false,
        'views' => false,
      ),
    ),
    'display_settings' => 
    array (
      'weight' => '-2',
      'parent' => '',
       4 => 
      array (
        'format' => 'hidden',
        'exclude' => 1,
      ),
     'label' => 
      array (
        'format' => 'hidden',
      ),
      'teaser' => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
      'full' => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
    ),
  );
  
  $noticias_tags = array(
  
    'label' => 'Tags',
    'field_name' => 'field_noticias_tags',
    'type' => 'content_taxonomy',
    'widget_type' => 'content_taxonomy_autocomplete',
    'change' => 'Change basic information',
    'weight' => 0,
    'new_terms' => 'insert',
    'extra_parent' => '0',
    'maxlength' => '255',
    'description' => '<p class="ayuda-link">
<p class="enlace">Ayuda</p></p>
<p class="descripcion">Tags para categorizar su envío, si incluye más de un término sepárelos con el carácter coma ",". <br> Si introduce un término ya existente introduzca algún carácter y el campo se auto-completará. <br> (Este campo es obligatorio y no puede omitirse) </p>
',
    'default_value' => 
    array (
    ),
    'default_value_php' => '',
    'default_value_widget' => 
    array (
      'field_noticias_tags' => 
      array (
        'value' => '',
      ),
    ),
    'group' => false,
    'required' => 0,
    'multiple' => '1',
    'save_term_node' => 1,
    'vid' => '1',
    'parent' => '0',
    'parent_php_code' => '',
    'depth' => '',
    'op' => 'Guardar configuraciones del campo',
    'module' => 'content_taxonomy',
    'widget_module' => 'content_taxonomy_autocomplete',
    'columns' => 
    array (
      'value' => 
      array (
        'type' => 'int',
        'not null' => false,
        'sortable' => false,
      ),
    ),
    'display_settings' => 
    array (
      'weight' => 0,
      'parent' => '',
      'label' => 
      array (
        'format' => 'hidden',
      ),
      'teaser' => 
      array (
        'format' => 'link',
        'exclude' => 0,
      ),
      'full' => 
      array (
        'format' => 'link',
        'exclude' => 0,
      ),
      4 => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
      'token' => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
    ),
  );


  $pagina_cuerpo = array(
    'label' => 'Texto completo',
    'field_name' => 'field_pagina_cuerpo',
    'type' => 'text',
    'widget_type' => 'text_textarea',
    'change' => 'Change basic information',
    'weight' => '-2',
    'rows' => '20',
    'size' => 60,
    'description' => '<p class="ayuda-link">
<p class="enlace">Ayuda</p></p>
<p class="descripcion">Este campo es el contenido de la página. <br> (Este campo es obligatorio y no puede omitirse) </p>
',
    'default_value' => 
    array (
      0 => 
      array (
        'value' => '',
        'format' => '2',
        '_error_element' => 'default_value_widget][field_pagina_cuerpo][0][value',
      ),
    ),
    'default_value_php' => '',
    'default_value_widget' => 
    array (
      'field_pagina_cuerpo' => 
      array (
        0 => 
        array (
          'value' => '',
          'format' => '2',
          '_error_element' => 'default_value_widget][field_pagina_cuerpo][0][value',
        ),
      ),
    ),
    'group' => false,
    'required' => 1,
    'multiple' => '0',
    'text_processing' => '1',
    'max_length' => '',
    'allowed_values' => '',
    'allowed_values_php' => '',
    'op' => 'Guardar configuraciones del campo',
    'module' => 'text',
    'widget_module' => 'text',
    'columns' => 
    array (
      'value' => 
      array (
        'type' => 'text',
        'size' => 'big',
        'not null' => false,
        'sortable' => true,
        'views' => true,
      ),
      'format' => 
      array (
        'type' => 'int',
        'unsigned' => true,
        'not null' => false,
        'views' => false,
      ),
    ),
    'display_settings' => 
    array (
      'weight' => '-2',
      'parent' => '',
      'label' => 
      array (
        'format' => 'hidden',
      ),
      'teaser' => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
      'full' => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
      4 => 
      array (
        'format' => 'default',
        'exclude' => 0,
      ),
    ),
  );  
  ttantta_instalar_cck($noticias_entradilla, 'noticias');
  ttantta_instalar_cck($noticias_cuerpo, 'noticias');
  ttantta_instalar_cck($noticias_tags, 'noticias');
  ttantta_instalar_cck($pagina_cuerpo, 'pagina');

}


/**
 * Add and delete items from the menus.
 */
function ttantta_modificar_menus() {
  
  db_query("INSERT INTO {menu_custom} (menu_name, title, description ) VALUES ('%s', '%s', '%s')", 'menu-principal', 'Menú principal', 'Menú de principal del portal"' );
  $menu_principal = array(
    array(
      'menu_name' => 'menu-principal',
      'link_title' => t('Contactar'),
      'link_path' => 'contact',
      'weight' => 40,
   ),
  );
  foreach ($menu_principal as $item) {
    menu_link_save($item);
  }
} // function _ttantta_modify_menus




/**
 * Set the roles and permissions that will be used in this profile.
 */
function ttantta_anadir_permissions() {
  // Define new roles.
  db_query("INSERT INTO {role} (rid, name) VALUES(%d, '%s')", 3, 'gestion');

  
  /**
   * Generate cuenta de usuario de gestor
   * @Todo quitar este usuario
  */
  $user = new stdClass();
  $edit['name'] = 'gestor';
  $edit['mail'] = valid_email_address($_SERVER['SERVER_ADMIN']) ? $_SERVER['SERVER_ADMIN'] : 'aitor@investic.net';
  $edit['status'] = 1;
  $edit['roles'][3] = 'gestion';
  $user = user_save($user,  $edit);
  $GLOBALS['user'] = $user;

  // PERMISOS
  $perm_anonimo = 'access comments, post comments, post comments without approval, subscribe to comments, access site-wide contact form, view imagecache noticias_full, view imagecache noticias_teaser, access content, search content, view uploaded files, access all views';
  db_query("INSERT INTO {permission} (rid, perm, tid) VALUES (1, '%s', 0)", $perm_anonimo);
  $perm_autent =  'access comments, post comments, post comments without approval, subscribe to comments, access site-wide contact form, view imagecache noticias_full, view imagecache noticias_teaser, access content, search content, view uploaded files, access all views';
  db_query("INSERT INTO {permission} (rid, perm, tid) VALUES (2, '%s', 0)", $perm_autent);
  $perm_gestor = 'administer blocks, administer comments, administer panel gestion, administer menu, administer nodes, create noticias content, create pagina content, delete any noticias content, delete any pagina content, delete own noticias content, delete own pagina content, delete revisions, edit any noticias content, edit any pagina content, edit own noticias content, edit own pagina content, create url aliases, search content, access site reports, administer taxonomy, upload files, administer users, use advanced search, access statistics, view post access counter, access site reports';
  db_query("INSERT INTO {permission} (rid, perm, tid) VALUES (3, '%s', 0)", $perm_gestor);

}

/**
 * Import CCK settings.
 *
 * @param $field
 *   The data provided by var_export(content_fields(fieldname, content_type)).
 * @param $content_type
 *   The content type that this field should be added to.
 */
function ttantta_instalar_cck($field, $content_type) {
  module_load_include('inc', 'content', 'includes/content.crud');

  $field['type_name'] = $content_type;
  content_field_instance_create($field);
} // function _ttantta_install_cck


