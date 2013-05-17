import jinja2 
import os
import codecs


def url(date, binary):
    return "builds/{0}/{0}-{1}.zip".format(date, binary)


def main():
    builds = []

    for date in os.listdir("builds"):
        if date.startswith("."):
            continue

        builds.append({
            'date': date,
            'urls': {
                'app': url(date, 'osx-app'),
                'framework': url(date, 'osx-framework'),
            },
        })

    handle = codecs.open('templates/index.html', 'r', 'utf-8')
    template = jinja2.Template(handle.read())


    with codecs.open('index.html', 'w', 'utf-8') as f:
        f.write(template.render(builds=builds))


if __name__ == "__main__":
    main()
