zipFile = null
loading = false
valid = true
get = (name) -> document.getElementById(name).value
error = (name) ->
    document.getElementById(name).parentElement.classList.add('has-error')
    document.getElementById('error-alert').classList.remove('hidden')
    valid = false

document.getElementById('submit').addEventListener('click', () ->
    a.classList.remove('has-error') for a in document.querySelectorAll('.has-error')
    document.getElementById('error-alert').classList.add('hidden')
    valid = true

    name = get('mod-name')
    shortDescription = get('mod-short-description')
    license = get('mod-license')
    if license == 'Other'
        license = get('mod-other-license')
    version = get('mod-version')
    kspVersion = get('mod-ksp-version')

    error('mod-name') if name == ''
    error('mod-short-description') if shortDescription == ''
    error('mod-license') if license == ''
    error('mod-version') if version == ''

    return unless valid
    return if loading
    loading = true

    xhr = new XMLHttpRequest()
    xhr.open('POST', '/api/mod/create')
    xhr.onload = () ->
        result = JSON.parse(this.responseText)
        if not result.error?
            window.location = JSON.parse(this.responseText).url + "?new=True"
        else
            alert = document.getElementById('error-alert')
            alert.classList.remove('hidden')
            alert.textContent = result.message
            document.getElementById('submit').removeAttribute('disabled')
            document.querySelector('.upload-mod a').classList.remove('hidden')
            document.querySelector('.upload-mod p').classList.add('hidden')
            loading = false
    form = new FormData()
    form.append('name', name)
    form.append('short-description', shortDescription)
    form.append('license', license)
    form.append('version', version)
    form.append('ksp-version', kspVersion)
    form.append('zipball', zipFile)
    document.getElementById('submit').setAttribute('disabled', 'disabled')
    xhr.send(form)
, false)

document.getElementById('mod-license').addEventListener('change', () ->
    license = get('mod-license')
    if license == 'Other'
        document.getElementById('mod-other-license').classList.remove('hidden')
    else
        document.getElementById('mod-other-license').classList.add('hidden')
, false)

document.querySelector('.upload-mod a').addEventListener('click', (e) ->
    e.preventDefault()
    document.querySelector('.upload-mod input').click()
, false)

document.querySelector('.upload-mod input').addEventListener('change', (e) ->
    zipFile = e.target.files[0]
    parent = document.querySelector('.upload-mod')
    parent.querySelector('a').classList.add('hidden')
    p = document.createElement('p')
    p.textContent = 'Ready.'
    parent.appendChild(p)
, false)

document.getElementById('submit').removeAttribute('disabled')
