Name: cookbook-samza
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: Samza cookbook to install and configure it in redborder environments

License: AGPL 3.0
URL: https://github.com/redBorder/cookbook-samza
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/samza
cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/samza
chmod -R 0755 %{buildroot}/var/chef/cookbooks/samza
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/samza/README.md

%pre

%post

%files
%defattr(0755,root,root)
/var/chef/cookbooks/samza
%defattr(0644,root,root)
/var/chef/cookbooks/samza/README.md


%doc

%changelog
* Fri Sep 22 2023 Miguel Negrón <manegron@redborder.com> - 2.0.0-1
- Remove social
* Tue Nov 08 2016 Carlos J. Mateos <cjmateos@redborder.com> - 1.0.0-1
- first spec version
