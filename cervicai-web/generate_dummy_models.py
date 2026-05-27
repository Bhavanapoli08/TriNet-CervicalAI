"""Generate random model weight files for local development only.

These files are random-initialized weights and are NOT useful for real predictions.
Place real trained `.pth` files in the `models/` directory to run actual inference.
"""
from __future__ import annotations
import os
import torch
from torchvision import models


def build_resnet50():
    m = models.resnet50(weights=None)
    m.fc = torch.nn.Linear(m.fc.in_features, 5)
    return m


def build_densenet121():
    m = models.densenet121(weights=None)
    m.classifier = torch.nn.Linear(m.classifier.in_features, 5)
    return m


def build_efficientnet_b3():
    m = models.efficientnet_b3(weights=None)
    m.classifier[1] = torch.nn.Linear(m.classifier[1].in_features, 5)
    return m


def main():
    base = os.path.dirname(__file__)
    models_dir = os.path.join(base, 'models')
    os.makedirs(models_dir, exist_ok=True)

    mappings = {
        'resnet50.pth': build_resnet50,
        'densenet121.pth': build_densenet121,
        'efficientnet_b3.pth': build_efficientnet_b3,
    }

    for name, builder in mappings.items():
        path = os.path.join(models_dir, name)
        print(f'Creating {path} ...')
        m = builder()
        # leave random init
        torch.save(m.state_dict(), path)

    print('Dummy model files created in', models_dir)


if __name__ == '__main__':
    main()
