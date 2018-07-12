


def write_og_file(title:str):
    space_stripped_title = title.replace(" ", "")
    content = '''<html prefix="og: http://ogp.me/ns#">
    <head>
        <title>''' + title +  '''</title>
        <meta property="og:title" content="''' + title + '''" />
        <meta property="og:type" content="website" />
        <meta property="og:description" content="WOW! Just look at this trophy I got in Arena Bingo! Collect cards and get your trophies, too!" />
        <meta property="og:url" content="https://static-bingo2.alisagaming.net/assets-prod/last-cdn/og/''' + space_stripped_title + '''.html" />
        <meta property="og:image" content="https://static-bingo2.alisagaming.net/assets-prod/last-cdn/og/''' + space_stripped_title + '''.png" />
        <meta property="fb:app_id" content="128427124377299" />
        <meta property="og:title" content="''' + title + '''" />
    </head>
    <script> top.location.href="http://apps.facebook.com/arenabingo/" </script>
</html>'''
    with open('assets_dist/og/' + space_stripped_title  + ".html", "w+") as og_file:
        og_file.write(content);
        og_file.flush()


write_og_file('Dragons 1')
write_og_file('Pirates 1')
write_og_file('Farm 1')
write_og_file('Maya 1')
write_og_file('Egypt 1')
write_og_file('Wild West 1')
write_og_file('Dragons 2')
write_og_file('Pirates 2')
write_og_file('Farm 2')
write_og_file('Maya 2')
write_og_file('Egypt 2')
write_og_file('Wild West 2')