import yaml

def test_image_is_untagged_and_version_set():
    with open('obsidian/config.yaml') as f:
        cfg = yaml.safe_load(f)
    version = str(cfg['version'])
    assert version, 'version must be specified'
    # If using a pre-built image, it must not include a tag
    if 'image' in cfg:
        image = str(cfg['image'])
        assert ':' not in image, 'image must not include a tag'
